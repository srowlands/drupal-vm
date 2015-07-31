core = 7.x
api = 2

projects[drupal][version] = 7.38
projects[drupal][patch][] = https://www.drupal.org/files/issues/drupal-7.x-allow_profile_change_sys_req-1772316-28.patch
projects[drupal][patch][] = https://www.drupal.org/files/issues/drupal-1470656-26.patch
projects[drupal][patch][] = https://www.drupal.org/files/issues/core-111702-99-use_replyto.patch

; Download the govCMS install profile and recursively build all its dependencies:
projects[govcms][version] = 2.x-dev

; Download extra modules for dev environments:
projects[devel][version] = 1.x-dev
projects[stage_file_proxy] = 1.7
