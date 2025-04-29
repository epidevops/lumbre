class ImageAttachmentHandler {
  static DEBUG = true;  // Debug flag - set to true to enable logging

  static log(...args) {
    if (this.DEBUG) {
      console.log('[ImageAttachmentHandler]', ...args);
    }
  }

  constructor(inputContainer) {
    this.constructor.log('Initializing for container:', inputContainer);

    const fileInput = inputContainer.querySelector('input[type="file"]');
    if (!fileInput) {
      this.constructor.log('No file input found, returning early');
      return;
    }

    // Parse name attribute: "admin_user[avatar]" -> ["admin_user", "avatar"]
    const nameMatch = fileInput.name.match(/^([^\[]+)\[([^\]]+)\]$/);
    if (!nameMatch) {
      this.constructor.log('Invalid name format:', fileInput.name);
      return;
    }

    this.form = inputContainer.closest('form');
    this.objectName = nameMatch[1];    // e.g., "admin_user"
    this.objectClassName = this.objectName.replace(/_/g, '-');    // e.g., "admin-user"
    this.methodName = nameMatch[2];    // e.g., "avatar"


    this.constructor.log('Parsed from name attribute:', {
      objectName: this.objectName,
      objectClassName: this.objectClassName,
      methodName: this.methodName,
    });

    this.elements = {
      container: inputContainer,
      fileInput: fileInput,
      cameraContainer: inputContainer.querySelector(`#image_attachment_container_camera_${this.objectName}_${this.methodName}`),
      imageContainer: inputContainer.querySelector(`#image_attachment_container_image_${this.objectName}_${this.methodName}`),
      deleteContainer: inputContainer.querySelector(`#image_attachment_container_delete_${this.objectName}_${this.methodName}`)
    };

    this.constructor.log('Found elements:', {
      fileInput: !!this.elements.fileInput,
      cameraContainer: !!this.elements.cameraContainer,
      imageContainer: !!this.elements.imageContainer,
      deleteContainer: !!this.elements.deleteContainer
    });

    this.init();
  }

  init() {
    if (!this.elements.fileInput) {
      this.constructor.log('No file input found, returning early');
      return;
    }
    this.bindEvents();
  }

  bindEvents() {
    this.constructor.log('Binding events for:', this.objectName, this.methodName);
    this.bindContainerClicks();
    this.bindFileInput();
    this.bindDeleteContainer();
  }

  bindContainerClicks() {
    let isProcessing = false;

    const handleClick = (event) => {
      this.constructor.log('Click event triggered on:', event.target);
      if (isProcessing) {
        this.constructor.log('Still processing previous click, ignoring');
        return;
      }

      event.preventDefault();
      event.stopPropagation();

      this.constructor.log('Triggering file input click');
      isProcessing = true;
      this.elements.fileInput.click();

      setTimeout(() => {
        this.constructor.log('Reset processing flag');
        isProcessing = false;
      }, 300);
    };

    // Bind click handlers directly to camera and image containers
    if (this.elements.cameraContainer) {
      this.constructor.log('Adding click listener to camera container');
      this.elements.cameraContainer.addEventListener('click', handleClick);
    }

    if (this.elements.imageContainer) {
      this.constructor.log('Adding click listener to image container');
      this.elements.imageContainer.addEventListener('click', handleClick);
    }
  }

  bindFileInput() {
    this.constructor.log('Binding file input handler');
    this.elements.fileInput.addEventListener('change', (event) => {
      const file = event.target.files[0];
      if (!file) {
        this.constructor.log('No file selected');
        return;
      }
      this.constructor.log('File selected:', file.name);

      const reader = new FileReader();
      reader.onload = (e) => {
        const imageSrc = e.target.result;
        const imageClass = `image-attachment-image-attached-${this.objectClassName}-${this.methodName}`

        this.constructor.log('imageClass: ', imageClass);
        this.constructor.log('Image loaded, updating UI');
        // avatarContainer.innerHTML = `<img src="${e.target.result}" alt="Avatar preview" class="avatar-attached-image">`;
        if (this.elements.imageContainer) {
          this.elements.imageContainer.innerHTML = `
            <img
              aria-hidden="true"
              class="${imageClass}"
              src="${imageSrc}"
            >`;
        }

        if (this.objectName === 'admin_user' && this.methodName === 'avatar' && window.Current) {
          this.constructor.log('Updating admin user avatar');
          window.Current.updateAvatar(imageSrc);
        }

        const updateTarget = this.elements.fileInput.dataset.updateTarget;
        const eventName = this.elements.fileInput.dataset.eventName || 'image:updated';

        this.constructor.log('Dispatching event:', eventName);
        document.dispatchEvent(new CustomEvent(eventName, {
          detail: {
            imageSrc,
            target: updateTarget,
            objectName: this.objectName,
            methodName: this.methodName
          }
        }));
      };
      reader.readAsDataURL(file);
    });
  }

  bindDeleteContainer() {
    if (!this.elements.deleteContainer) {
      this.constructor.log('No delete container found');
      return;
    }

    this.constructor.log('Binding delete container handler');
    this.elements.deleteContainer.addEventListener('click', (event) => {
      this.constructor.log('Delete clicked');
      event.preventDefault();
      event.stopPropagation();
      // image - attachment - delete -file - admin - user - avatar
      const deleteLinkQuerySelector = `.image-attachment-delete-file-${this.objectClassName}-${this.methodName}`
      this.constructor.log('  deleteLinkQuerySelector = ', deleteLinkQuerySelector);
      const deleteLink = this.form.querySelector(`.image-attachment-delete-file-${this.objectClassName}-${this.methodName}`);
      // const deleteLink = this.form.querySelector(`.image-attachment-delete-file-${this.objectName}-${this.methodName}`);
      this.constructor.log('DeleteLink = ', deleteLink);
      if (deleteLink) {
        this.constructor.log('Triggering delete link click');
        deleteLink.click();

        if (this.objectName === 'admin_user' && this.methodName === 'avatar' && window.Current) {
          this.constructor.log('Updating admin user avatar to null');
          window.Current.updateAvatar(null);
        }

        const updateTarget = this.elements.fileInput.dataset.updateTarget;
        const eventName = this.elements.fileInput.dataset.eventName || 'image:updated';

        document.dispatchEvent(new CustomEvent(eventName, {
          detail: {
            deleted: true,
            target: updateTarget,
            objectName: this.objectName,
            methodName: this.methodName
          }
        }));
      }
    });
  }
}

document.addEventListener('current:initialized', () => {
  console.log('currentInitialized Fom Image Attagment')
  if (!document.body.classList.contains('logged_in')) return;
  if (document.querySelectorAll('li.image_attachment').length === 0) return;

  const imageAttachmentContainers = document.querySelectorAll('li.image_attachment');
  ImageAttachmentHandler.log('Found image attachment containers:', imageAttachmentContainers.length);

  imageAttachmentContainers.forEach(container => {
    new ImageAttachmentHandler(container);
  });
});
