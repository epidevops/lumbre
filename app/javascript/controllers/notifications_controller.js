import { Controller } from "@hotwired/stimulus"
import { post } from "@rails/request.js"
import { pageIsTurboPreview } from "helpers/turbo_helpers"
import { onNextEventLoopTick } from "helpers/timing_helpers"
import { getCookie, setCookie } from "lib/cookie"

export default class extends Controller {
  static values = {
    subscriptionsUrl: String,
    debug: { type: Boolean, default: false }
  }
  static targets = ["notAllowedNotice", "bell", "details"]
  static classes = ["attention"]

  #log(...args) {
    if (this.debugValue) {
      console.log(...args);
    }
  }

  async connect() {
    this.#log("Notifications controller connected");
    if (!pageIsTurboPreview()) {
      if (window.notificationsPreviouslyReady) {
        this.#log("Notifications previously ready");
        onNextEventLoopTick(() => this.dispatch("ready"))
      } else {
        this.#log("Checking if notifications are enabled");
        const firstTimeReady = await this.isEnabled()
        this.#log("First time ready:", firstTimeReady);

        this.#pulseBellButton()

        if (firstTimeReady) {
          this.#log("Dispatching ready event");
          onNextEventLoopTick(() => this.dispatch("ready"))
          window.notificationsPreviouslyReady = true
        } else {
          this.#log("Showing bell alert");
          this.#showBellAlert()
        }
      }
    }
  }

  async attemptToSubscribe() {
    this.#log("Attempting to subscribe");
    if (this.#allowed) {
      this.#log("Notifications are allowed");
      const registration = await this.#serviceWorkerRegistration || await this.#registerServiceWorker()
      this.#log("Service Worker registration:", registration);

      switch (Notification.permission) {
        case "denied": {
          this.#log("Notification permission denied");
          this.#revealNotAllowedNotice();
          break;
        }
        case "granted": {
          this.#log("Notification permission granted");
          this.#subscribe(registration);
          break;
        }
        case "default": {
          this.#log("Requesting notification permission");
          this.#requestPermissionAndSubscribe(registration);
        }
      }
    } else {
      this.#log("Notifications not allowed");
      this.#revealNotAllowedNotice()
    }

    this.#endFirstRun()
  }

  async isEnabled() {
    this.#log("Checking if notifications are enabled");
    if (this.#allowed) {
      const registration = await this.#serviceWorkerRegistration
      this.#log("Service Worker registration:", registration);
      const existingSubscription = await registration?.pushManager?.getSubscription()
      this.#log("Existing subscription:", existingSubscription);

      return Notification.permission == "granted" && registration && existingSubscription
    } else {
      this.#log("Notifications not allowed");
      return false
    }
  }

  get #allowed() {
    return navigator.serviceWorker && window.Notification
  }

  get #serviceWorkerRegistration() {
    return navigator.serviceWorker.getRegistration(window.location.origin)
  }

  #registerServiceWorker() {
    return navigator.serviceWorker.register("/service-worker.js")
  }

  #revealNotAllowedNotice() {
    this.notAllowedNoticeTarget.showModal()
    this.#openSingleOption()
  }

  #openSingleOption() {
    const visibleElements = this.detailsTargets.filter(item => !this.#isHidden(item))

    if (visibleElements.length === 1) {
      this.detailsTargets.forEach(item => item.toggleAttribute("open", item === visibleElements[0]))
    }
  }

  #showBellAlert() {
    this.bellTarget.querySelectorAll("img").forEach(img => img.toggleAttribute("hidden"))
  }

  async #pulseBellButton() {
    const shouldPulse = await this.#noSubscriptionExists();
    if (shouldPulse) {
      this.bellTarget.classList.add(this.attentionClass);
    }
  }

  async #noSubscriptionExists() {
    if (!this.#allowed) return true;
    const registration = await this.#serviceWorkerRegistration;
    const existingSubscription = await registration?.pushManager?.getSubscription();
    return !existingSubscription;
  }

  #endFirstRun() {
    this.bellTarget.classList.remove(this.attentionClass)
    this.#markFirstRunSeen()
  }

  async #subscribe(registration) {
    this.#log("Subscribing to push notifications");
    registration.pushManager
      .subscribe({ userVisibleOnly: true, applicationServerKey: this.#vapidPublicKey })
      .then(subscription => {
        this.#log("Push subscription successful:", subscription);
        this.#syncPushSubscription(subscription)
        this.dispatch("ready")
      })
      .catch(error => {
        console.error("Push subscription failed:", error);
      })
  }

  async #syncPushSubscription(subscription) {
    this.#log("Syncing push subscription");
    const response = await post(this.subscriptionsUrlValue, { body: this.#extractJsonPayloadAsString(subscription), responseKind: "turbo-stream" })
    this.#log("Sync response:", response);
    if (!response.ok) {
      console.error("Failed to sync subscription");
      subscription.unsubscribe()
    }
  }

  async #requestPermissionAndSubscribe(registration) {
    const permission = await Notification.requestPermission()
    if (permission === "granted") this.#subscribe(registration)
  }

  get #vapidPublicKey() {
    const encodedVapidPublicKey = document.querySelector('meta[name="vapid-public-key"]').content
    this.#log("Encoded VAPID public key:", encodedVapidPublicKey);
    return this.#urlBase64ToUint8Array(encodedVapidPublicKey)
  }

  get #hasSeenFirstRun() {
    if (this.#isPWA) {
      return getCookie("notifications-pwa-first-run-seen")
    } else {
      return getCookie("notifications-first-run-seen")
    }
  }

  #markFirstRunSeen = (event) => {
    if (this.#isPWA) {
      setCookie("notifications-pwa-first-run-seen", true)
    } else {
      setCookie("notifications-first-run-seen", true)
    }
  }

  #extractJsonPayloadAsString(subscription) {
    const { endpoint, keys: { p256dh, auth } } = subscription.toJSON()
    return JSON.stringify({ push_subscription: { endpoint, p256dh_key: p256dh, auth_key: auth } })
  }

  // VAPID public key comes encoded as base64 but service worker registration needs it as a Uint8Array
  #urlBase64ToUint8Array(base64String) {
    const padding = "=".repeat((4 - base64String.length % 4) % 4)
    const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/")

    const rawData = window.atob(base64)
    const outputArray = new Uint8Array(rawData.length)

    for (let i = 0; i < rawData.length; ++i) {
      outputArray[i] = rawData.charCodeAt(i)
    }

    return outputArray
  }

  #isHidden(item) {
    return (item.offsetParent === null)
  }

  get #isPWA() {
    return window.matchMedia("(display-mode: standalone)").matches
  }
}
