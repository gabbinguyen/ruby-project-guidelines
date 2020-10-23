require_relative '../config/environment'
require_relative '../app/api_communicator'
require_relative '../app/command_line_interface'
require_relative '../app/models/user'
require_relative '../app/models/restaurant'
require_relative '../app/models/bar'
require_relative '../app/models/reservation'

system ("clear")
app = DateManager.new
app.welcome
app.create_menu
