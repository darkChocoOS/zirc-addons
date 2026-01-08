# Using this Template

## Prep Work

1) copy this template

2) enable github actions on the new repo

3) clone the repo locally

## Setup

1) enter into your local repository

2) delete `cosign.pub` and generate cosign keys
  - with cosign
    ```bash
    # generate cosign.key and cosign.pub
    # cosign.key is your private key
    # cosign.pub is your public key
    cosign generate-key-pair
    ```
  - with skopeo
    ```bash
    # generate cosign.key and cosign.pub
    # cosign.private is your private key
    # cosign.pub is your public key
    skopeo generate-sigstore-key --output-prefix cosign
    ```

3) add private key to github repository secrets
  - web client
    1. go to Settings -> Secrets and variables -> actions
    2. create new repository secret and name it `SIGNING_SECRET`
    3. copy `cosign.key`/`cosign.private` to the new secret

  - github cli
    ```bash
    gh secret set SIGNING_KEY < cosign.key # or cosign.private
    ```

4) setup Containerfile
  - set base image uri
  - set `bootc-template` to your image's name (in lowercase)

5) fix signing
  - go through system_files/etc/containers and replace all instances of `darkchocoos` with the your username or organization name in lowercase, depending on who owns the image repo. there should be 3 instances of this
  - go to system_files/etc/containers/policy.json and replace `bootc-template` with your image's name (in lowercase)

6) make changes to image desc and image keywords in .github/workflows/build.yml
  - **DO NOT MAKE ANY OTHER CHANGES TO BUILD.YML**

7) modify build_files/build.sh and add files to system_files as you see fit

8) commit and push changes

## Using Image

1) switch to your image
  ```bash
  sudo bootc switch ghcr.io/<username/org_name>/<image_name>
  ```
  
2) reboot

3) rebase to signed image
  ```bash
  sudo bootc switch ghcr.io/<username/org_name>/<image_name>
  ```
