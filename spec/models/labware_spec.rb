# See README.md for copyright details

require 'rails_helper'
require 'uuid'

RSpec.describe Labware, type: :model do

  it 'should create a valid object' do
    expect(build(:labware_with_receptacles)).to be_valid
  end

  it 'should be invalid without labware type' do
    expect(build(:labware, labware_type: nil)).to_not be_valid
  end

  it 'should be valid without an external id' do
    expect(build(:labware_with_receptacles, external_id: nil)).to be_valid
  end

  it 'should build a barcode with the correct format' do
    labware = create(:labware_with_receptacles, barcode_prefix: 'TEST', barcode_info: 'XYZ', id: 123)

    expect(labware.barcode).to eq('TEST-XYZ-00000123')
  end

  it 'should create a uuid only when it\'s created' do
    labware = build(:labware_with_receptacles)
    expect(labware.uuid.size).to eq(36)
    uuid = labware.uuid

    labware.save!

    expect(Labware.find(labware.id).uuid).to eq(uuid)
  end

  it 'should create a barcode only when it\'s created' do
    labware = create(:labware_with_receptacles)
    expect(labware.barcode).to_not be_empty
    barcode = labware.barcode

    expect(Labware.find(labware.id).barcode).to eq(barcode)
  end

  it 'should use the barcode if given one' do
    labware = create(:labware_with_receptacles, barcode: 'test_barcode')

    expect(Labware.find(labware.id).barcode).to eq('test_barcode')
  end

  it 'should use the uuid if given one' do
    uuid = UUID.new.generate
    labware = create(:labware_with_receptacles, uuid: uuid)

    expect(Labware.find(labware.id).uuid).to eq(uuid)
  end

  it 'should test the barcode does not already exist' do
    labware = create(:labware_with_receptacles, barcode: 'test barcode')

    expect(build(:labware_with_receptacles, barcode: labware.barcode)).to_not be_valid
  end

  it 'should test the uuid does not already exist' do
    labware = create(:labware_with_receptacles, uuid: UUID.new.generate)

    expect(build(:labware_with_receptacles, uuid: labware.uuid)).to_not be_valid
  end

  it 'should test the external_id does not already exist' do
    external_id = 'test_external_id'
    labware = create(:labware_with_receptacles, external_id: external_id)

    expect(build(:labware_with_receptacles,  external_id: external_id)).to_not be_valid
  end

  it 'should be valid without a prefix if a barcode is given' do
    expect(build(:labware_with_receptacles, barcode_prefix: nil, barcode: 'test_barcode')).to be_valid
  end

  it 'should not be valid without a prefix or barcode' do
    expect(build(:labware_with_receptacles, barcode_prefix: '')).to_not be_valid
  end

  it 'should not be valid without a prefix or barcode' do
    expect(build(:labware_with_receptacles, barcode_prefix: nil)).to_not be_valid
  end
end
