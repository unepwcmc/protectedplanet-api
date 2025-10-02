
## What's New in v4

Version 4 introduces several enhancements and new endpoints:

- **Protected Area Parcels**: New endpoints for accessing individual parcels within protected areas
- **Updated Data Structure**: Updated field names and additional attributes for improved clarity. Please see below for field changes


## Migration from v3

**Important**: While v4 introduces breaking changes (mainly field name changes), v3 will remain available until the time mentioned above to allow time for migration. Please review the changes below and update your integration accordingly.

### Protected Areas Response Changes

#### Fields Removed:
- id → `site_id` - Previously an alias for `wdpa_id`. Use `site_id` in v4
- sub_locations - Sub-location data is no longer captured for protected areas

#### Fields Renamed:
- wdpa_id → `site_id`
- wdpa_pid → `site_pid` - It is 'string' format in v4
- name → `name_english` - English name of the protected area
- original_name → `name` - Original name in local language
- marine_type → `realm` - See next section for return values

#### Fields Added:
- `site_type` - Distinguishes between protected areas ('pa') and other effective area-based conservation measures ('oecm'). (Return either value of `pa`, `oecm`)
- `realm` - Indicates the environmental domain. Returns an object with `id` and `name` fields. Name values include `Terrestrial`, `Coastal`, `Marine`
- `governance_subtype` - Additional governance classification details (String)
- `ownership_subtype` - Additional ownership classification details (String)
- `inland_waters` - Information about inland water coverage (String)
- `oecm_assessment` - Assessment information for OECMs (String)
- `sources` - Array containing data source information with `id`, `title`, `responsible_party`, and `year_updated` fields
- `protected_area_parcels` - Array containing detailed information for all parcels within the protected area. Returns an empty array if no parcels exist. See Parcel Integration section below for detailed structure



#### API URL Changes:
- **v3**: `/v3/*`
- **v4**: `/v4/*`

### Countries API
- **No changes** - The Countries API maintains identical response structure and fields between v3 and v4

### New Features in v4

#### Protected Area Parcels
- **New Resource**: Complete new set of endpoints for accessing individual parcels within protected areas
- **Enhanced Detail**: Access granular data for each parcel that makes up a protected area
- **Comprehensive Coverage**: All protected area endpoints now include a `protected_area_parcels` array

#### Parcel Integration
- Protected area responses now include a `protected_area_parcels` array containing all parcels
- The primary protected area data represents the first parcel
- The `protected_area_parcels` array includes all parcels (including the first one) for complete coverage
- Each parcel object contains similar structure as the main protected area object. [See example response structure](/documentation#get-v4protectedareaparcelssiteid)