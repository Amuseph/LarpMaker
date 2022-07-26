require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

import jQuery from 'jquery';
window.$ = window.jQuery = jQuery;
import 'bootstrap'
import 'select2'