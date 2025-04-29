class Current {
  static instance = null;

  constructor() {
    if (Current.instance) return Current.instance;
    Current.instance = this;
    this._user = null;
  }

  initializeUser(userData) {
    this._user = userData;
  }

  updateAvatar(imageSrc) {
    if (this._user) {
      this._user.url = imageSrc;
      Current.loadAvatar();
    }
  }

  get user() {
    return this._user;
  }

  static async initialize() {

    if (!document.body.classList.contains('logged_in')) return;

    const userDataTag = document.querySelector('meta[name="current-user-data"]');
    if (!userDataTag) return;

    // Create Current instance if it doesn't exist
    if (!window.Current) {
      window.Current = new Current();
      window.Current.initializeUser({
        ...Current.extractDataFromContent(userDataTag.content)
      });

      // Load avatar after user initialization
      Current.loadAvatar();

      document.dispatchEvent(new CustomEvent('current:initialized'));
    }
  }

  static extractDataFromContent(content) {
    const { first_name: firstName, initials, avatar: { url } } = JSON.parse(content);
    console.log(first_name)
    return { firstName, initials, url };
  }

  static async loadAvatar() {
    const headerAvatar = document.querySelector('#header #utility_nav #current_user a');
    if (!headerAvatar || !this.instance.user) return;

    try {
      const HAS_INITIALS = 'has-initials';
      const HAS_AVATAR = 'has-avatar';

      // Remove existing classes first
      headerAvatar.classList.remove(HAS_INITIALS, HAS_AVATAR);

      const USER_URL_NULL = this.instance.user.url === null;

      const imageSrc = USER_URL_NULL
        ? Current.createInitialsDataUrl(this.instance.user.initials)
        : this.instance.user.url;

      headerAvatar.style.backgroundImage = `url(${imageSrc})`;
      headerAvatar.classList.add(USER_URL_NULL ? HAS_INITIALS : HAS_AVATAR);
    } catch (error) {
      console.error('Error processing avatar data:', error);
    }
  }

  static createInitialsDataUrl(initials) {
    const canvas = document.createElement('canvas');
    const padding = 2;
    canvas.width = 100;
    canvas.height = 100;
    const ctx = canvas.getContext('2d');

    const innerWidth = canvas.width - (padding * 2);
    const innerHeight = canvas.height - (padding * 2);

    ctx.fillStyle = '#4bacfe';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    ctx.fillStyle = 'white';
    ctx.font = 'bold 40px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(initials, canvas.width / 2, canvas.height / 2);

    return canvas.toDataURL();
  }
}

// Initialize on load to ensure this runs first
document.addEventListener('DOMContentLoaded', async () => {
  await Current.initialize();
});