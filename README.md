# Chef Cookbook Gui
[![Build Status](https://travis-ci.org/codenamephp/chef.cookbook.gui.svg?branch=dev)](https://travis-ci.org/codenamephp/chef.cookbook.gui)

Cookbook to install linux guis like cinnamon, gnome, ...

The default cookbook is a No-Op. To install a gui, add the respective cookbook to your runlist.

## Requirements

### Supported Platforms

- Debian Stretch

### Suported GUIs
- cinnamon
- xfce

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

### Attributes

#### Cinnamon

- `['codenamephp_gui']['cinnamon']['package_name']` - The package name that is used 
  to install cinnamon, defaults to `'cinnamon-core'` to install the minimal version of cinnamon

#### xfce

- `['codenamephp_gui']['xfce']['package_name']` - The package name that is used 
  to install xfce, defaults to `'xfce'` to install the minimal version of xfce
