# frozen_string_literal: true

require 'spec_helper'

describe 'codenamephp_gui_genome_gsettings' do
  step_into :codenamephp_gui_genome_gsettings

  context 'Add with minimal attributes' do
    recipe do
      codenamephp_gui_genome_gsettings 'Set value' do
        schema 'my.schema'
        key 'my-key'
        value 'myValue'
      end
    end

    it 'will execute the command' do
      expect(chef_run).to run_execute('Set gsettings value').with(
        command: 'gsettings set my.schema my-key myValue'
      )
    end
  end
end