# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "Adobe_AdditionalMetadata", primary_key: "id_local", force: :cascade do |t|
    t.string "id_global"
    t.integer "additionalInfoSet"
    t.integer "embeddedXmp"
    t.integer "externalXmpIsDirty"
    t.integer "image"
    t.integer "incrementalWhiteBalance"
    t.string "internalXmpDigest"
    t.integer "isRawFile"
    t.string "lastSynchronizedHash"
    t.decimal "lastSynchronizedTimestamp", precision: 20, scale: 10
    t.string "metadataPresetID"
    t.decimal "metadataVersion", precision: 20, scale: 5
    t.integer "monochrome"
    t.string "xmp"
  end

# Could not dump table "Adobe_faceProperties" because of following StandardError
#   Unknown type '' for column 'propertiesString'

  create_table "Adobe_imageDevelopBeforeSettings", primary_key: "id_local", force: :cascade do |t|
    t.string "beforeDigest"
    t.decimal "beforeHasDevelopAdjustments", precision: 20, scale: 10
    t.string "beforePresetID"
    t.string "beforeText"
    t.integer "developSettings"
  end

  create_table "Adobe_imageDevelopSettings", primary_key: "id_local", force: :cascade do |t|
    t.integer "allowFastRender"
    t.decimal "beforeSettingsIDCache", precision: 20, scale: 5
    t.string "croppedHeight"
    t.string "croppedWidth"
    t.string "digest"
    t.decimal "fileHeight", precision: 20, scale: 5
    t.decimal "fileWidth", precision: 20, scale: 5
    t.integer "grayscale"
    t.integer "hasDevelopAdjustments"
    t.decimal "hasDevelopAdjustmentsEx", precision: 10, scale: 5
    t.string "historySettingsID"
    t.integer "image"
    t.decimal "processVersion", precision: 10, scale: 5
    t.decimal "profileCorrections", precision: 5, scale: 5
    t.decimal "removeChromaticAberration", precision: 5, scale: 5
    t.string "settingsID"
    t.string "snapshotID"
    t.string "text"
    t.decimal "validatedForVersion", precision: 10, scale: 5
    t.string "whiteBalance"
  end

# Could not dump table "Adobe_imageProofSettings" because of following StandardError
#   Unknown type '' for column 'colorProfile'

# Could not dump table "Adobe_imageProperties" because of following StandardError
#   Unknown type '' for column 'id_global'

  create_table "Adobe_images", primary_key: "id_local", force: :cascade do |t|
    t.string "id_global"
    t.decimal "aspectRatioCache", precision: 20, scale: 10
    t.decimal "bitDepth", precision: 10, scale: 5
    t.datetime "captureTime"
    t.decimal "colorChannels", precision: 10, scale: 5
    t.string "colorLabels"
    t.integer "colorMode"
    t.decimal "copyCreationTime", precision: 20, scale: 10
    t.string "copyName"
    t.string "copyReason"
    t.decimal "developSettingsIDCache", precision: 20, scale: 5
    t.string "fileFormat"
    t.decimal "fileHeight", precision: 20, scale: 5
    t.decimal "fileWidth", precision: 20, scale: 5
    t.integer "hasMissingSidecars"
    t.integer "masterImage"
    t.string "orientation"
    t.decimal "originalCaptureTime", precision: 20, scale: 10
    t.integer "originalRootEntity"
    t.integer "panningDistanceH"
    t.integer "panningDistanceV"
    t.decimal "pick", precision: 10, scale: 5
    t.string "positionInFolder"
    t.decimal "propertiesCache", precision: 20, scale: 10
    t.string "pyramidIDCache"
    t.decimal "rating", precision: 10, scale: 5
    t.integer "rootFile"
    t.decimal "sidecarStatus", precision: 10, scale: 5
    t.decimal "touchCount", precision: 10, scale: 5
    t.decimal "touchTime", precision: 20, scale: 10
  end

# Could not dump table "Adobe_libraryImageDevelop3DLUTColorTable" because of following StandardError
#   Unknown type '' for column 'LUTFullString'

  create_table "Adobe_libraryImageDevelopHistoryStep", primary_key: "id_local", force: :cascade do |t|
    t.string "id_global"
    t.decimal "dateCreated", precision: 20, scale: 10
    t.string "digest"
    t.decimal "hasDevelopAdjustments", precision: 10, scale: 5
    t.integer "image"
    t.string "name"
    t.string "relValueString"
    t.binary "text"
    t.string "valueString"
  end

# Could not dump table "Adobe_libraryImageDevelopSnapshot" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "Adobe_libraryImageFaceProcessHistory" because of following StandardError
#   Unknown type '' for column 'lastFaceDetector'

# Could not dump table "Adobe_namedIdentityPlate" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "Adobe_variables" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "Adobe_variablesTable" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgDNGProxyInfo" because of following StandardError
#   Unknown type '' for column 'fileUUID'

# Could not dump table "AgDNGProxyInfoUpdater" because of following StandardError
#   Unknown type '' for column 'taskID'

# Could not dump table "AgDeletedOzAlbumAssetIds" because of following StandardError
#   Unknown type '' for column 'ozCatalogId'

# Could not dump table "AgDeletedOzAlbumIds" because of following StandardError
#   Unknown type '' for column 'ozCatalogId'

# Could not dump table "AgDeletedOzAssetIds" because of following StandardError
#   Unknown type '' for column 'ozCatalogId'

# Could not dump table "AgDeletedOzSpaceIds" because of following StandardError
#   Unknown type '' for column 'ozCatalogId'

# Could not dump table "AgFolderContent" because of following StandardError
#   Unknown type '' for column 'id_global'

  create_table "AgHarvestedDNGMetadata", primary_key: "id_local", force: :cascade do |t|
    t.integer "image"
    t.integer "hasFastLoadData"
    t.integer "hasLossyCompression"
    t.integer "isDNG"
    t.integer "isHDR"
    t.integer "isPano"
    t.integer "isReducedResolution"
    t.index ["hasFastLoadData", "image", "isDNG", "hasLossyCompression", "isReducedResolution", "isPano", "isHDR"], name: "index_AgHarvestedDNGMetadata_byHasFastLoadData"
    t.index ["hasLossyCompression", "image", "isDNG", "hasFastLoadData", "isReducedResolution", "isPano", "isHDR"], name: "index_AgHarvestedDNGMetadata_byHasLossyCompression"
    t.index ["image", "isDNG", "hasFastLoadData", "hasLossyCompression", "isReducedResolution", "isPano", "isHDR"], name: "index_AgHarvestedDNGMetadata_byImage"
    t.index ["isDNG", "image", "hasFastLoadData", "hasLossyCompression", "isReducedResolution", "isPano", "isHDR"], name: "index_AgHarvestedDNGMetadata_byIsDNG"
    t.index ["isHDR", "image", "isDNG", "hasFastLoadData", "hasLossyCompression", "isReducedResolution", "isPano"], name: "index_AgHarvestedDNGMetadata_byIsHDR"
    t.index ["isPano", "image", "isDNG", "hasFastLoadData", "hasLossyCompression", "isReducedResolution", "isHDR"], name: "index_AgHarvestedDNGMetadata_byIsPano"
    t.index ["isReducedResolution", "image", "isDNG", "hasFastLoadData", "hasLossyCompression", "isPano", "isHDR"], name: "index_AgHarvestedDNGMetadata_byIsReducedResolution"
  end

  create_table "AgHarvestedExifMetadata", primary_key: "id_local", force: :cascade do |t|
    t.integer "image"
    t.decimal "aperture", precision: 10, scale: 10
    t.integer "cameraModelRef"
    t.integer "cameraSNRef"
    t.decimal "dateDay", precision: 5, scale: 1
    t.decimal "dateMonth", precision: 5, scale: 1
    t.decimal "dateYear", precision: 10, scale: 1
    t.integer "flashFired"
    t.decimal "focalLength", precision: 10, scale: 1
    t.string "gpsLatitude"
    t.string "gpsLongitude"
    t.decimal "gpsSequence", precision: 20, scale: 10
    t.integer "hasGPS"
    t.decimal "isoSpeedRating", precision: 20, scale: 5
    t.integer "lensRef"
    t.decimal "shutterSpeed", precision: 20, scale: 10
  end

# Could not dump table "AgHarvestedIptcMetadata" because of following StandardError
#   Unknown type '' for column 'locationDataOrigination'

# Could not dump table "AgHarvestedMetadataWorklist" because of following StandardError
#   Unknown type '' for column 'taskID'

  create_table "AgInternedExifCameraModel", primary_key: "id_local", force: :cascade do |t|
    t.string "searchIndex"
    t.string "value"
  end

# Could not dump table "AgInternedExifCameraSN" because of following StandardError
#   Unknown type '' for column 'searchIndex'

  create_table "AgInternedExifLens", primary_key: "id_local", force: :cascade do |t|
    t.string "searchIndex"
    t.string "value"
  end

# Could not dump table "AgInternedIptcCity" because of following StandardError
#   Unknown type '' for column 'searchIndex'

# Could not dump table "AgInternedIptcCountry" because of following StandardError
#   Unknown type '' for column 'searchIndex'

# Could not dump table "AgInternedIptcCreator" because of following StandardError
#   Unknown type '' for column 'searchIndex'

# Could not dump table "AgInternedIptcIsoCountryCode" because of following StandardError
#   Unknown type '' for column 'searchIndex'

# Could not dump table "AgInternedIptcJobIdentifier" because of following StandardError
#   Unknown type '' for column 'searchIndex'

# Could not dump table "AgInternedIptcLocation" because of following StandardError
#   Unknown type '' for column 'searchIndex'

# Could not dump table "AgInternedIptcState" because of following StandardError
#   Unknown type '' for column 'searchIndex'

  create_table "AgLastCatalogExport", primary_key: "image", force: :cascade do |t|
  end

# Could not dump table "AgLibraryCollection" because of following StandardError
#   Unknown type '' for column 'creationId'

# Could not dump table "AgLibraryCollectionChangeCounter" because of following StandardError
#   Unknown type '' for column 'collection'

# Could not dump table "AgLibraryCollectionContent" because of following StandardError
#   Unknown type '' for column 'content'

# Could not dump table "AgLibraryCollectionCoverImage" because of following StandardError
#   Unknown type '' for column 'collection'

# Could not dump table "AgLibraryCollectionImage" because of following StandardError
#   Unknown type '' for column 'pick'

# Could not dump table "AgLibraryCollectionImageChangeCounter" because of following StandardError
#   Unknown type '' for column 'collectionImage'

# Could not dump table "AgLibraryCollectionImageOzAlbumAssetIds" because of following StandardError
#   Unknown type '' for column 'collectionImage'

# Could not dump table "AgLibraryCollectionImageOzSortOrder" because of following StandardError
#   Unknown type '' for column 'collectionImage'

# Could not dump table "AgLibraryCollectionOzAlbumIds" because of following StandardError
#   Unknown type '' for column 'collection'

# Could not dump table "AgLibraryCollectionStack" because of following StandardError
#   Unknown type '' for column 'id_global'

  create_table "AgLibraryCollectionStackData", id: false, force: :cascade do |t|
    t.integer "stack"
    t.integer "collection", default: 0, null: false
    t.integer "stackCount", default: 0, null: false
    t.integer "stackParent"
    t.index ["stack", "collection", "stackCount", "stackParent"], name: "index_AgLibraryCollectionStackData"
  end

# Could not dump table "AgLibraryCollectionStackImage" because of following StandardError
#   Unknown type '' for column 'position'

# Could not dump table "AgLibraryCollectionSyncedAlbumData" because of following StandardError
#   Unknown type '' for column 'collection'

# Could not dump table "AgLibraryCollectionTrackedAssets" because of following StandardError
#   Unknown type '' for column 'collection'

# Could not dump table "AgLibraryFace" because of following StandardError
#   Unknown type '' for column 'bl_x'

  create_table "AgLibraryFaceCluster", primary_key: "id_local", force: :cascade do |t|
    t.integer "keyFace"
    t.index ["keyFace"], name: "index_AgLibraryFaceCluster_keyFace"
  end

# Could not dump table "AgLibraryFaceData" because of following StandardError
#   Unknown type '' for column 'data'

  create_table "AgLibraryFile", primary_key: "id_local", force: :cascade do |t|
    t.string "id_global"
    t.string "baseName"
    t.string "errorMessage"
    t.decimal "errorTime", :precision => 20, :scale => 10
    t.string "extension"
    t.decimal "externalModTime", :precision => 20, :scale => 10
    t.string "folder"
    t.string "importHash"
    t.string "lc_idx_filename"
    t.string "lc_idx_filenameExtension"
    t.string "md5"
    t.decimal "modTime", :precision => 20, :scale => 10
    t.string "originalFilename"
    t.string "sidecarExtensions"
  end

# Could not dump table "AgLibraryFileAssetMetadata" because of following StandardError
#   Unknown type '' for column 'fileId'

# Could not dump table "AgLibraryFolder" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgLibraryFolderFavorite" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgLibraryFolderLabel" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgLibraryFolderStack" because of following StandardError
#   Unknown type '' for column 'id_global'

  create_table "AgLibraryFolderStackData", id: false, force: :cascade do |t|
    t.integer "stack"
    t.integer "stackCount", default: 0, null: false
    t.integer "stackParent"
    t.index ["stack", "stackCount", "stackParent"], name: "index_AgLibraryFolderStackData"
  end

# Could not dump table "AgLibraryFolderStackImage" because of following StandardError
#   Unknown type '' for column 'position'

# Could not dump table "AgLibraryIPTC" because of following StandardError
#   Unknown type '' for column 'caption'

# Could not dump table "AgLibraryImageChangeCounter" because of following StandardError
#   Unknown type '' for column 'image'

# Could not dump table "AgLibraryImageOzAssetIds" because of following StandardError
#   Unknown type '' for column 'image'

# Could not dump table "AgLibraryImageSearchData" because of following StandardError
#   Unknown type '' for column 'featInfo'

# Could not dump table "AgLibraryImageSyncedAssetData" because of following StandardError
#   Unknown type '' for column 'image'

# Could not dump table "AgLibraryImageXMPUpdater" because of following StandardError
#   Unknown type '' for column 'taskID'

# Could not dump table "AgLibraryImport" because of following StandardError
#   Unknown type '' for column 'imageCount'

  create_table "AgLibraryImportImage", primary_key: "id_local", force: :cascade do |t|
    t.integer "image", default: 0, null: false
    t.integer "import", default: 0, null: false
    t.index ["image", "import"], name: "index_AgLibraryImportImage_imageAndImport", unique: true
    t.index ["import"], name: "index_AgLibraryImportImage_import"
  end

  create_table "AgLibraryKeyword", primary_key: "id_local", force: :cascade do |t|
    t.string "id_global"
    t.decimal "dateCreated", :precision => 20, :scale => 10
    t.string "genealogy"
    t.decimal "imageCountCache", :precision => 20, :scale => 10
    t.integer "includeOnExport"
    t.integer "includeSynonyms"
    t.string "keywordType"
    t.decimal "lastApplied", :precision => 20, :scale => 10
    t.string "lc_name"
    t.string "name"
    t.integer "parent"
  end

# Could not dump table "AgLibraryKeywordCooccurrence" because of following StandardError
#   Unknown type '' for column 'tag1'

# Could not dump table "AgLibraryKeywordFace" because of following StandardError
#   Unknown type '' for column 'rankOrder'

  create_table "AgLibraryKeywordImage", primary_key: "id_local", force: :cascade do |t|
    t.integer "image", default: 0, null: false
    t.integer "tag", default: 0, null: false
    t.index ["image"], name: "index_AgLibraryKeywordImage_image"
    t.index ["tag"], name: "index_AgLibraryKeywordImage_tag"
  end

# Could not dump table "AgLibraryKeywordPopularity" because of following StandardError
#   Unknown type '' for column 'occurrences'
  create_table "AgLibraryKeywordPopularity", primary_key: "id_local", force: :cascade do |t|
    t.decimal "occurrences", :precision => 20, :scale => 5
    t.decimal "popularity", :precision => 20, :scale => 10
    t.decimal "tag", :precision => 20, :scale => 5
  end

  create_table "AgLibraryKeywordSynonym", primary_key: "id_local", force: :cascade do |t|
    t.integer "keyword"
    t.string "lc_name"
    t.string "name"
  end

# Could not dump table "AgLibraryOzCommentIds" because of following StandardError
#   Unknown type '' for column 'ozCatalogId'

# Could not dump table "AgLibraryOzFavoriteIds" because of following StandardError
#   Unknown type '' for column 'ozCatalogId'

# Could not dump table "AgLibraryOzFeedbackInfo" because of following StandardError
#   Unknown type '' for column 'image'

# Could not dump table "AgLibraryPublishedCollection" because of following StandardError
#   Unknown type '' for column 'creationId'

# Could not dump table "AgLibraryPublishedCollectionContent" because of following StandardError
#   Unknown type '' for column 'content'

# Could not dump table "AgLibraryPublishedCollectionImage" because of following StandardError
#   Unknown type '' for column 'pick'

# Could not dump table "AgLibraryRootFolder" because of following StandardError
#   Unknown type '' for column 'id_global'

  create_table "AgLibraryUpdatedImages", primary_key: "image", force: :cascade do |t|
  end

# Could not dump table "AgMRULists" because of following StandardError
#   Unknown type '' for column 'listID'

# Could not dump table "AgMetadataSearchIndex" because of following StandardError
#   Unknown type '' for column 'exifSearchIndex'

# Could not dump table "AgOutputImageAsset" because of following StandardError
#   Unknown type '' for column 'assetId'

# Could not dump table "AgOzSpaceAlbumIds" because of following StandardError
#   Unknown type '' for column 'ozCatalogId'

# Could not dump table "AgOzSpaceIds" because of following StandardError
#   Unknown type '' for column 'ozCatalogId'

# Could not dump table "AgPendingOzAlbumAssetIds" because of following StandardError
#   Unknown type '' for column 'ozCatalogId'

# Could not dump table "AgPendingOzAssetBinaryDownloads" because of following StandardError
#   Unknown type '' for column 'ozAssetId'

# Could not dump table "AgPendingOzAssets" because of following StandardError
#   Unknown type '' for column 'ozAssetId'

# Could not dump table "AgPhotoComment" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgPhotoProperty" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgPhotoPropertyArrayElement" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgPhotoPropertySpec" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgPublishListenerWorklist" because of following StandardError
#   Unknown type '' for column 'taskID'

# Could not dump table "AgRemotePhoto" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgSearchablePhotoProperty" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgSearchablePhotoPropertyArrayElement" because of following StandardError
#   Unknown type '' for column 'id_global'

# Could not dump table "AgSourceColorProfileConstants" because of following StandardError
#   Unknown type '' for column 'profileName'

# Could not dump table "AgSpecialSourceContent" because of following StandardError
#   Unknown type '' for column 'content'

  create_table "AgTempImages", primary_key: "image", force: :cascade do |t|
  end

# Could not dump table "AgUnsupportedOzAssets" because of following StandardError
#   Unknown type '' for column 'ozAssetId'

# Could not dump table "AgVideoInfo" because of following StandardError
#   Unknown type '' for column 'duration'

# Could not dump table "LrMobileSyncChangeCounter" because of following StandardError
#   Unknown type '' for column 'id'

# Could not dump table "MigratedCollectionImages" because of following StandardError
#   Unknown type '' for column 'ozAlbumId'

# Could not dump table "MigratedCollections" because of following StandardError
#   Unknown type '' for column 'ozAlbumId'

# Could not dump table "MigratedImages" because of following StandardError
#   Unknown type '' for column 'ozAssetId'

# Could not dump table "MigratedInfo" because of following StandardError
#   Unknown type '' for column 'migrationStatus'

  create_table "MigrationSchemaVersion", primary_key: "version", id: :text, force: :cascade do |t|
  end

# Could not dump table "sqlite_stat1" because of following StandardError
#   Unknown type '' for column 'tbl'

# Could not dump table "sqlite_stat4" because of following StandardError
#   Unknown type '' for column 'tbl'

end
