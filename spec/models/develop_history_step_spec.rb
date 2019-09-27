# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevelopHistoryStep, type: :model do
  describe 'scopes' do
    let(:develop_step) { create(:develop_history_step) }

    before do
      develop_step
    end

    describe 'for_setting' do
      before do
        develop_step.update!(name: step_name)
      end

      context 'when the step name matches' do
        let(:step_name) { 'Contrast' }

        it 'is included in the results' do
          expect(DevelopHistoryStep.for_setting('Contrast')).to include develop_step
        end
      end

      context 'when the step name does not match' do
        let(:step_name) { 'Highlights' }

        it 'is not included in the results' do
          expect(DevelopHistoryStep.for_setting('Contrast')).not_to include develop_step
        end
      end
    end

    describe 'negative' do
      before do
        develop_step.update!(valueString: value)
      end

      context 'when the value string has a negative value' do
        let(:value) { '-10' }

        it 'is included in the results' do
          expect(DevelopHistoryStep.negative).to include develop_step
        end
      end

      context 'when the value string has a positive value' do
        let(:value) { '7' }

        it 'is not included in the results' do
          expect(DevelopHistoryStep.negative).not_to include develop_step
        end
      end
    end

    describe 'positive' do
      before do
        develop_step.update!(valueString: value)
      end

      context 'when the value string has a positive value' do
        let(:value) { '10' }

        it 'is included in the results' do
          expect(DevelopHistoryStep.positive).to include develop_step
        end
      end

      context 'when the value string has a negative value' do
        let(:value) { '-7' }

        it 'is not included in the results' do
          expect(DevelopHistoryStep.positive).not_to include develop_step
        end
      end
    end
  end
end
