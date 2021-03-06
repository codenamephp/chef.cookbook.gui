# Chef Cookbook Gui
[![Build Status](https://travis-ci.com/codenamephp/chef.cookbook.gui.svg?branch=master)](https://travis-ci.com/codenamephp/chef.cookbook.gui)

Cookbook to install linux guis like cinnamon, gnome, ...

The default cookbook is a No-Op. To install a gui, add the respective cookbook to your runlist.

## Deprecated
This cookbook is now deprecated and won't be getting any updates. 

## Requirements

### Supported Platforms

- Debian Stretch

### Suported GUIs
- cinnamon
- xfce4
- gnome

### Chef

- Chef 13.0+

### Cookbook Depdendencies

- apt

## Usage

Add the cookbook to your Berksfile:

```ruby
cookbook 'codenamephp_gui'
```

Add the gui cookbook to your runlist, e.g. in a role:

```json
{
  "name": "default",
  "chef_type": "role",
  "json_class": "Chef::Role",
  "run_list": [
	  "recipe[codenamephp_gui::cinnamon]"
  ]
}
```

Note that the default recipe is a No-Op, so you need to add the gui you want

### Recipes
Each recipe just uses the respective resource without any arguments. They are meant to use as a shortcut in a runlist or via chef manage gui. If you need some
additional properties use the resources in a wrapper cookbook.

### Resources

### Cinnamon
The `codenamephp_gui_cinnamon` resource installs or uninstalls the cinnamon gui.

#### Actions
- `:install`: Installs the gui using apt and starts and enables the lightdm display manager
- `:uninstall`: Uninstalls the lightdm display manager

#### Properties
- `package_name`: The name of the apt package to use for install, defaults to 'cinnamon-core'
- `lightdm`: Boolean to enable or disable the lightdm handling, defaults to true

#### Examples
```ruby
# Minmal parameters
codenamephp_gui_cinnamon 'install cinnamon gui'

# Custom package name and disabled lightdm
codenamephp_gui_cinnamon 'install cinnamon gui' do
  package_name 'cinnamon'
  lightdm false
end

# Uninstall
codenamephp_gui_cinnamon 'install cinnamon gui' do
  action :uninstall
end
```

### XFCE4
The `codenamephp_gui_xfce` resource installs or uninstalls the xfce4 gui.

#### Actions
- `:install`: Installs the gui using apt and starts and enables the lightdm display manager
- `:uninstall`: Uninstalls the lightdm display manager

#### Properties
- `package_name`: The name of the apt package to use for install, defaults to 'xfce4-core'
- `lightdm`: Boolean to enable or disable the lightdm handling, defaults to true

#### Examples
```ruby
# Minmal parameters
codenamephp_gui_xfce4 'install xfce4 gui'

# Custom package name and disabled lightdm
codenamephp_gui_xfce4 'install xfce4 gui' do
  package_name 'xfce4'
  lightdm false
end

# Uninstall
codenamephp_gui_xfce4 'install xfce4 gui' do
  action :uninstall
end
```

### Gnome
The `codenamephp_gui_xfce` resource installs or uninstalls the gnome gui.

#### Actions
- `:install`: Installs the gui using apt
- `:uninstall`: Uninstalls the gui using apt

#### Properties
- `package_name`: The name of the apt package to use for install, defaults to 'gnome-core'

#### Examples
```ruby
# Minmal parameters
codenamephp_gui_gnome 'install gnome gui'

# Custom package name
codenamephp_gui_gnome 'install gnome gui' do
  package_name 'gnome'
end

# Uninstall
codenamephp_gui_gnome 'install gnome gui' do
  action :uninstall
end
```
### Gnome Gsettings
Resource to set gsettings configurations. There are constants in `CodenamePHP::Gui::Helper::Gnome::GSettings` that can be used for known schemas and keys

#### Actions
- `:set`: Sets the configuration

#### Properties
- `schema`: The schema the configuration is located in, e.g. 'org.gnome.desktop.session'
- `key`: The key within the schema to be set, e.g. 'idle-delay'
- `value`: The value to set, e.g. '0'
- `users`: The users to set the settings for as array of usernames

#### Examples
```ruby
# Minimal parameters
codenamephp_gui_gnome_gsettings 'Set display idle delay' do
  schema CodenamePHP::Gui::Helper::Gnome::GSettings::SCHEMA_DESKTOP_SESSION
  key CodenamePHP::Gui::Helper::Gnome::GSettings::KEY_DESKTOP_SESSION_IDLE_DELAY
  value '0'
  users ['test']
end
```

### Gnome Keyboard Shortcuts
The `codenamephp_gui_gnome_keyboard_shortcuts` resource adds custom shortcuts for the gnome desktop. This is done by getting the custom shortcuts using gsettings
and then adding the new shortcut and adds back all shortcuts. If a shortcut with the same name already exists it is replaced by the new one

#### Actions
- `set`: Sets a new or replaces an existing shortcut

#### Properties
- `shortcut_name`: The name of the shortcut to set, defaults to the resource name
- `command`: The command the shortcut should execute
- `binding`: The keys the shortcut consists of, also see the `CodenamePHP::Gui::Helper::Gnome::GSettings::Keys::*` constants
- `users`: The users to set the shortcuts for as array of usernames

#### Examples
```ruby
codenamephp_gui_gnome_keyboard_shortcut 'Terminal' do
  command 'gnome-terminal --maximize'
  binding "#{CodenamePHP::Gui::Helper::Gnome::GSettings::Keys::SUPER}#{CodenamePHP::Gui::Helper::Gnome::GSettings::Keys::ALT}t"
  users ['test']
end
```
