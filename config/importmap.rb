# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'hotkeys-js', to: 'https://ga.jspm.io/npm:hotkeys-js@3.8.9/dist/hotkeys.esm.js'
pin 'stimulus-dropdown', to: 'https://ga.jspm.io/npm:stimulus-dropdown@2.0.0/dist/stimulus-dropdown.es.js'
pin 'stimulus-use', to: 'https://ga.jspm.io/npm:stimulus-use@0.50.0-2/dist/index.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin 'application', preload: true
pin 'local-time', to: 'https://ga.jspm.io/npm:local-time@2.1.0/app/assets/javascripts/local-time.js'
pin 'tailwindcss-stimulus-components', to: 'https://ga.jspm.io/npm:tailwindcss-stimulus-components@3.0.4/dist/tailwindcss-stimulus-components.modern.js'

pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'app/components', under: 'components'
pin 'stimulus-autocomplete', to: 'https://ga.jspm.io/npm:stimulus-autocomplete@3.0.2/src/autocomplete.js'
pin '@hotwired/stimulus', to: 'https://ga.jspm.io/npm:@hotwired/stimulus@3.0.1/dist/stimulus.js'
pin 'chartkick', to: 'chartkick.js'
pin 'Chart.bundle', to: 'Chart.bundle.js'
