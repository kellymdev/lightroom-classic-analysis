# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrequencyValuesHelper, type: :helper do
  describe '.display_value' do
    context 'when the value is true' do
      it 'is Yes' do
        expect(helper.display_value(true)).to eq 'Yes'
      end
    end

    context 'when the value is false' do
      it 'is No' do
        expect(helper.display_value(false)).to eq 'No'
      end
    end

    context 'when the value is numeric' do
      it 'is the value' do
        expect(helper.display_value(3)).to eq 3
      end
    end

    context 'when the value is text' do
      it 'is the value' do
        expect(helper.display_value('Custom')).to eq 'Custom'
      end
    end
  end
end
