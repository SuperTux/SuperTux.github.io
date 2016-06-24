---
layout: post
title: "In-game Level Editor Merged"
date: 2016-06-24 11:56:00
---

After almost a year of hard work by Hume2, and contributions by Tobbi and Karkus, on a new in-game level editor, we're pleased to announce our decision of merging the development branch into our master branch!

As this is a large change to the code base, and we intend the editor to be the major new feature in SuperTux v0.5.0, this will need some serious testing. For this reason, we're asking you, the community, to help find bugs and also provide us with feedback and suggestions for changes that could be integrated before the 0.5.0 release. Please report bugs here: [on GitHub](https://github.com/SuperTux/supertux/issues/new) and follow the bug [reporting guidelines](https://github.com/SuperTux/supertux/blob/master/CONTRIBUTING.md#bug-reports).

We would like to avoid publishing a release with a large number of issues, as occurred with the 0.4.0 release. We apologize for those problems.

In order for the testing phase to be effective, we need as many people as possible to help test the current development state. This is the reason we provide nightly builds for many major Linux distributions, Windows, and OS X. They can be found [here](https://download.supertuxproject.org/download/).

Another important consequence of this change is that there are many new, untranslated strings. The translation resources have been updated on Transifex and are waiting to be translated. We need to highlight that there have been changes made in the translation process to ensure the quality of translations. These decisions are summarized in [a comment on issue \#351](https://github.com/SuperTux/supertux/issues/351#issuecomment-228104965). If you want to see your language included in SuperTux 0.5.0, please make sure the translations meet the new requirements listed there. In addition, we're aware of problems with some translations due to unsupported characters, broken font direction setup or missing character shaping. This issue is being worked on and will be addressed in the 0.6.0 release. For information, see [issue \#130](https://github.com/SuperTux/supertux/issues/130).

To ensure the translations are included in 0.5.0, you should start to work on the as soon as possible. Strings will be frozen 2 weeks before the release date (we will send out an announcement to translators when that occurs), so please raise concerns with strings before that deadline. In these 2 weeks, only minor localization updates should happen.
