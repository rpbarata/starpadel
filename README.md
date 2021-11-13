# Star Padel BO

**Important**

Ask your team for the .env file

## Setup with Docker (recommended)

1. Make sure you have your ssh keys in the home folder of the OS that is running docker

### Linux/Mac

1. Install `docker`, `docker-compose`, `VScode` (optional)
2. Install `Remote - Containers` VScode extension (optional)

### Windows

1. Follow https://docs.microsoft.com/en-us/windows/wsl/install-win10#manual-installation-steps` instructions
2. Install `Docker Desktop`, `VScode`
3. Clone project inside a WSL folder subsystem (\\\wsl$\Ubuntu)
4. Enable WSL Integration with the installed distro in Docker Desktop, Settings, Resourses, WSL Integration

### General

1. Ask for the .env file and paste it in the current folder
2. Open `VScode` and install `Remote - Containers` vscode extension
3. In the lower left corner, there will be a green area. Press it and select `Remote-Containers: Reopen in Container`
4. In the bottom right corner, there will be a popup to install the recommended extensions
5. A terminal should also be visible with 3 options, choose option `q`

## Setup without Docker

### Dependencies

- [Ruby  _3.0.0_](https://www.ruby-lang.org/en/documentation/installation/)
- [Rails  _6.1.4_](http://rubyonrails.org/)
- [PostgreSQL  _13.1_](https://www.postgresql.org/)

Try it at
http://localhost:3000/

## Branch naming and MRs properties

- **Branch name** \<prefix\>/\<snake_cased_task_title\>
- **MR name** Task title
- **MR assignee** Person responsible for the MR code
- **MR label** Type

|    Types    |   Prefix   |                                      Description                                      |
| :---------: | :---------: | :-----------------------------------------------------------------------------------: |
|   Bugfix   |   bugfix   |                Code previously written that is not working as intended                |
|   Feature   |   feature   |                          Code to create a new functionality                          |
| Improvement | improvement | Code clean up or adaptations to improve code readability, organization or performance |
|   Styling   |   styling   |                         Code purely dedicated to stylization                         |
|   DevOps    |    devops   | Code pipeline, production environment, docker configuration, etc |

## Labeled commentaries

|  Types  |                                         Description                                         |
| :------: | :------------------------------------------------------------------------------------------: |
|   NOTE   |                              Description of how the code works                              |
|  REVIEW  |                                     Needs to be verified                                     |
|   HACK   |             Not very well written or malformed code to circumvent a problem/bug             |
|  FIXME  |                       This works, sort of, but it could be done better                       |
|   BUG   |                                   There is a problem here                                   |
|   TODO   | No problem, but additional code needs to be written, usually when you are skipping something |
| OPTIMIZE |                             No problem, but code can be improved                             |
|  FUTURE  |                          Changes that should be made in the future                          |
