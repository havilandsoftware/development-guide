# Git and Github

## Installation & First Time Setup
Please follow the installation and first time setup instructions [here](../getting-started/installation-and-setup-guid.md#git).

## Repository Creation Standards
- Make it private
- Add README using documentation standards below
- Add your topics on Github page - we have set list to choose from below
- Add a description on Github page
- Update the merging strategy to only squash merge
- Set default branch to main
- Attach Github repository to the appropriate team
- Attach the repository to channel

## Branching
We follow a more consolidated/feature centric version of `git flow` as a branching strategy.
1. When work begins, the **developer** checks out and pulls code from main branch.
2. They then create a branch using the ticket name, e.g. `git checkout -b HS-1234-build-something`.  
3. All changes associated with that ticket should be committed in the branch.  
4. When the person is ready, they should push the branch and create a `pull request` in github.  A pull request allows the development team the chance to provide feedback and approve the changes.  
5. Once approved by a **peer** and the application is built through the CI/CD system, the **developer** is responsible for merging the changes into the `main` branch.


## Documentation
README documentation communicates how to work with the repository.  As the project changes, the README should include updates alongside their corresponding development changes.  And when creating a new repository, the README should include each section:
- Title and summary
- Prerequisites and installations
- Build
- Run
- Test
- Troubleshooting

```
# Title
.... summary goes Here

## Prerequisites
- Install [app 1](https://something/app/1)
- Install [app 2](https://something/app/2)
...

## Build

### Local Build

### Dev/Prod Build


## Testing
...

## Troubleshooting
### Issue number 1
....

### Issue number 2
....

## TODO
- [] First todo
- [] Second todo

```
