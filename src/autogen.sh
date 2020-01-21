#!/bin/bash
set -eux -o pipefail


RELATIVE_PATH="$(dirname "${BASH_SOURCE}")"
CURRENT_PATH=$(cd "${RELATIVE_PATH}"; pwd)

AUTOGEN_PATH="docker-templates"
mkdir "${CURRENT_PATH}/../${AUTOGEN_PATH}"

AUTOGEN_TARGET=$(cd "${CURRENT_PATH}/../${AUTOGEN_PATH}"; pwd)

pushd "${CURRENT_PATH}" >/dev/null

for dir in "platform/"*; do
  versions="$(cat "${dir}/VERSIONS")"

  platform="$(basename "${dir}")"
  for version in ${versions}; do
    dir="${AUTOGEN_TARGET}/${platform}-${version}"
    source_image="${platform}:${version}"
    dockerfile="${dir}/Dockerfile"

    echo "Preparing Dockerfile for ${source_image} in ${dockerfile}"
    mkdir -p "$dir"

    cp "${CURRENT_PATH}/Dockerfile.template" "${dockerfile}"

    perl -pe "s/__SOURCE_IMAGE__/'${source_image}'/ge" -i "${dockerfile}"
    pushd "${CURRENT_PATH}/platform/${platform}" >/dev/null
    perl -pe 's/_INSTALL_DEPS__/`cat install-deps | perl -pe "chomp if eof"`/ge' -i "${dockerfile}"
    popd >/dev/null

    perl -n -e 'print if /\S/' -i "${dockerfile}"

    echo "${source_image}" > "${dir}/SOURCE-TAG"
    echo "template/${platform}-base:${version}" > "${dir}/TAG"
  done
done

popd >/dev/null
