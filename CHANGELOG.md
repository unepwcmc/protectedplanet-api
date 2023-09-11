### 0.6.1
* switch back to passenger

### 0.6.0
* Confugure to use Puma as application server instead of phusion passenger

### 0.5.0
* Add GDPR question to User sign up
* Add new API fields: :wdpa_pid, :international_criteria, :verif, :parent_iso3, :marine_type, :gis_marine_area, :gis_area

### 0.4.2
**Add new fields to Countries JSON**
* Add :oecm_polygon_count, :oecm_point_count, :protected_area_polygon_count, :protected_area_point_count
* Add Dockerfile
* Update documentation

### 0.4.1
**Add new fields to Countries JSON**
* Add :percentage_oecms_pa_marine_cover, :oecms_pa_land_area, :oecms_pa_marine_area, :percentage_oecms_pa_land_cover
* Update documentation
### 0.4.0

**Add new fields to Protected Areas JSON**
* Add :green_list_status, :is_oecm, :supplementary_info, :conservation_objectives, and :green_list_url
* Update documentation

### 0.3.2

* Update the introduction text
* Update the alternatives alert
* Updated capistrano gems

### 0.3.1

* Update missing readme with missing details about setup
* Update the text about commercial use
* Update notification mailing list

### 0.3.0

* Remove obsolete fields returned by the endpoints
* Fix sidebar search endopoint link and add BIOPAMA link
* Add BIOPAMA endpoint to documentation

### 0.2.0

**Features**

* Add new endpoint for ACP countries (BIOPAMA) protected areas

**Bug fixes**

* Make sure Travis build passes by specifying 'trusty' distribution

### 0.1.1

**Add new fields to Protected Areas JSON**

* Added pame_evaluations

### 0.1.0

**Add new fields to Protected Areas JSON**

* Added governance
* Added no_take_status area
* Added reported_area
* Added reported_marine_area
* Added owner_type
* Improved documentation
