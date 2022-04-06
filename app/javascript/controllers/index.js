// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Eager load all controllers defined in the import map under app/javascript/controllers/**/*_controller
eagerLoadControllersFrom("controllers", application)

// Eager load all controllers defined in the import map under app/components/**/*_controller
eagerLoadControllersFrom("components", application)
