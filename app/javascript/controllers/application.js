import { Application } from '@hotwired/stimulus'

const application = Application.start()

import { Modal } from 'tailwindcss-stimulus-components'
application.register('modal', Modal)

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }
