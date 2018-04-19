# Changelog

## version 1.1

- switched to [lucas-kanade tool][1] for palate reconstruction
- palate reconstruction landmarks are now required
- adapted [default settings][2] for lucas-kanade tool
- segmentation type ADAPTIVE renamed to OTSU
- renamed gradle task: createHTML -> createTongueHTML
- removed unneeded settings from [default settings][2]
- swapped order: scan is first smoothed and then cropped (smoothed version can be used for palate reconstruction)
- updated [README][3]

[1]:https://github.com/m2ci-msp/mri-shape-tools/blob/master/lucas-kanade
[2]:./resources/settings/default.groovy
[3]:./README.md

## version 1.0

initial version
