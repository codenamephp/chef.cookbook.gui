# frozen_string_literal: true

codenamephp_gui_gnome 'install gnome'
codenamephp_gui_gnome_gsettings 'Set display idle delay' do
  schema CodenamePHP::Gui::Helper::GNOME::GSettings::SCHEMA_DESKTOP_SESSION
  key CodenamePHP::Gui::Helper::GNOME::GSettings::KEY_DESKTOP_SESSION_IDLE_DELAY
  value '0'
end
codenamephp_gui_gnome_keyboard_shortcut 'Add shortcut for terminal' do
  shortcut_name 'Terminal'
  command 'gnome-terminal --maximize'
  binding '<Primary><Alt>t'
end
