# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateCaptureTimeData, type: :service do
  describe '#call' do
    let(:image_1) { create(:image) }
    let(:image_2) { create(:image) }
    let(:image_3) { create(:image) }

    subject(:service) { described_class.new }

    before do
      image_1.update!(captureTime: capture_time_1)
      image_2.update!(captureTime: capture_time_2)
      image_3.update!(captureTime: capture_time_3)
    end

    context 'january' do
      let(:capture_time_1) { '2019-01-25T06:53:43' }
      let(:capture_time_2) { '2019-01-15T15:47:21' }
      let(:capture_time_3) { '2019-01-05T15:29:34' }

      let(:expected_result) do
        [
          {
            value: '15:00 - 15:59',
            percentage: 66.67
          },
          {
            value: '06:00 - 06:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for january' do
        expect(service.call[:january]).to eq expected_result
      end
    end

    context 'february' do
      let(:capture_time_1) { '2019-02-28T23:53:43' }
      let(:capture_time_2) { '2019-02-05T01:29:34' }
      let(:capture_time_3) { '2019-02-07T00:47:21' }

      let(:expected_result) do
        [
          {
            value: '23:00 - 23:59',
            percentage: 33.33
          },
          {
            value: '01:00 - 01:59',
            percentage: 33.33
          },
          {
            value: '00:00 - 00:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for february' do
        expect(service.call[:february]).to eq expected_result
      end
    end

    context 'march' do
      let(:capture_time_1) { '2019-03-28T09:53:43' }
      let(:capture_time_2) { '2019-03-05T15:29:34' }
      let(:capture_time_3) { '2019-03-07T09:47:21' }

      let(:expected_result) do
        [
          {
            value: '09:00 - 09:59',
            percentage: 66.67
          },
          {
            value: '15:00 - 15:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for march' do
        expect(service.call[:march]).to eq expected_result
      end
    end

    context 'april' do
      let(:capture_time_1) { '2019-04-28T00:53:43' }
      let(:capture_time_2) { '2019-04-05T23:29:34' }
      let(:capture_time_3) { '2019-04-07T12:47:21' }

      let(:expected_result) do
        [
          {
            value: '00:00 - 00:59',
            percentage: 33.33
          },
          {
            value: '23:00 - 23:59',
            percentage: 33.33
          },
          {
            value: '12:00 - 12:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for april' do
        expect(service.call[:april]).to eq expected_result
      end
    end

    context 'may' do
      let(:capture_time_1) { '2019-05-28T19:53:43' }
      let(:capture_time_2) { '2019-05-05T14:29:34' }
      let(:capture_time_3) { '2019-05-07T14:47:21' }

      let(:expected_result) do
        [
          {
            value: '14:00 - 14:59',
            percentage: 66.67
          },
          {
            value: '19:00 - 19:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for may' do
        expect(service.call[:may]).to eq expected_result
      end
    end

    context 'june' do
      let(:capture_time_1) { '2019-06-28T14:53:43' }
      let(:capture_time_2) { '2019-06-05T14:29:34' }
      let(:capture_time_3) { '2019-06-07T14:47:21' }

      let(:expected_result) do
        [
          {
            value: '14:00 - 14:59',
            percentage: 100
          }
        ]
      end

      it 'returns the most popular capture times for june' do
        expect(service.call[:june]).to eq expected_result
      end
    end

    context 'july' do
      let(:capture_time_1) { '2019-07-28T08:53:43' }
      let(:capture_time_2) { '2019-07-05T01:29:34' }
      let(:capture_time_3) { '2019-07-07T08:47:21' }

      let(:expected_result) do
        [
          {
            value: '08:00 - 08:59',
            percentage: 66.67
          },
          {
            value: '01:00 - 01:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for july' do
        expect(service.call[:july]).to eq expected_result
      end
    end

    context 'august' do
      let(:capture_time_1) { '2019-08-28T17:53:43' }
      let(:capture_time_2) { '2019-08-05T14:29:34' }
      let(:capture_time_3) { '2019-08-07T02:47:21' }

      let(:expected_result) do
        [
          {
            value: '17:00 - 17:59',
            percentage: 33.33
          },
          {
            value: '14:00 - 14:59',
            percentage: 33.33
          },
          {
            value: '02:00 - 02:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for august' do
        expect(service.call[:august]).to eq expected_result
      end
    end

    context 'september' do
      let(:capture_time_1) { '2019-09-28T22:53:43' }
      let(:capture_time_2) { '2019-09-05T03:29:34' }
      let(:capture_time_3) { '2019-09-07T11:47:21' }

      let(:expected_result) do
        [
          {
            value: '22:00 - 22:59',
            percentage: 33.33
          },
          {
            value: '03:00 - 03:59',
            percentage: 33.33
          },
          {
            value: '11:00 - 11:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for september' do
        expect(service.call[:september]).to eq expected_result
      end
    end

    context 'october' do
      let(:capture_time_1) { '2019-10-28T18:53:43' }
      let(:capture_time_2) { '2019-10-05T20:29:34' }
      let(:capture_time_3) { '2019-10-07T18:47:21' }

      let(:expected_result) do
        [
          {
            value: '18:00 - 18:59',
            percentage: 66.67
          },
          {
            value: '20:00 - 20:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for october' do
        expect(service.call[:october]).to eq expected_result
      end
    end

    context 'november' do
      let(:capture_time_1) { '2019-11-28T11:53:43' }
      let(:capture_time_2) { '2019-11-05T11:29:34' }
      let(:capture_time_3) { '2019-11-07T11:47:21' }

      let(:expected_result) do
        [
          {
            value: '11:00 - 11:59',
            percentage: 100
          }
        ]
      end

      it 'returns the most popular capture times for november' do
        expect(service.call[:november]).to eq expected_result
      end
    end

    context 'december' do
      let(:capture_time_1) { '2019-12-28T15:53:43' }
      let(:capture_time_2) { '2019-12-05T21:29:34' }
      let(:capture_time_3) { '2019-12-07T21:47:21' }

      let(:expected_result) do
        [
          {
            value: '21:00 - 21:59',
            percentage: 66.67
          },
          {
            value: '15:00 - 15:59',
            percentage: 33.33
          }
        ]
      end

      it 'returns the most popular capture times for december' do
        expect(service.call[:december]).to eq expected_result
      end
    end
  end
end
