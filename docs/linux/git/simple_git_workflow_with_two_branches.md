# Simple Git Workflow With Two Branches

Branches
--------

There are two main branches, Master and Deploy. Master contains the usuable
scripts and develop should contain working scripts.

One qustion that might arrise is, why there is a Master and Develop branch?  The 
reasoning for this is multiple people maybe working on deploy scripts at one time. 
Having the develop branch allows users to commit updates and pull down each others 
changes before commiting all changes to the Master branch. This also ensures that the Master branch is stable

Workflow
--------

The normal workflow for this repository should be the following

###Working on deploy scripts

1. Create a new feature branch related to the updates you are adding `(f_feature_name)`
1. Checkout the new feature branch to your work space:

    ```
    git checkout -b f_feature_name
    ```

1. Make any needed changes and commit them to your feature branch
1. Merge your changes back into the development branch:

    ```
    git checkout develop
    ```

1. Check your current branch to verify your moved to the devlop branch:

    ``` 
    git branch
    ```

1. Merge items back into development branch:

    ```
    git merge `f_feature_name`
    ```

1. Continue working on additional features.  Once everything has been done for the Release from all 
   participants perform the final merge and tag to Master.
   
### Final Master tag and push

1. As the final step, after all testing and script work is done, merge the development changes 
   into the master branch and tag it for the Sprint:

    ```
    git checkout master
    git merge -m "Adding Feature X" develop
    git log --pretty=oneline
    git tag -a <feature_tag> commit_hash
    git push --tags
    ```

[gimmick:Disqus](techtacoorg)
