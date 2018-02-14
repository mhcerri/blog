---
date: 2015-08-04T08:53:58Z
tags:
- python
- virtualenv
title: How to move a Python virtualenv to another directory
---

Every python script installed in the `./bin/` directory of a Python virtualenv installation has a shebang pointing to the absolute path of the python binary in the virtualenv. That's important to assure that those scripts will only be executed with the correct python binary.

However, when a Python virtualenv is moved to another directory all those scripts end up outdated.

To fix that, all that's necessary to do is:

```sh
virtualenv --relocatable ./path/to/virtualenv/dir/
```

