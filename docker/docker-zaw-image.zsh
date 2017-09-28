bindkey '^[<' zaw-rad-docker-image

function zaw-src-rad-docker-image() {
    title="$(docker images | head -n 1)"
    desc="$(docker images | tail +2)"
    : ${(A)candidates::=${(f)desc}}
    actions=(\
        zaw-rad-docker-image-run \
        zaw-rad-docker-image-push \
        zaw-rad-docker-image-pull \
        zaw-rad-docker-image-inspect \
        zaw-rad-docker-image-history \
        zaw-rad-docker-image-rmi \
        zaw-rad-docker-image-append-name-to-buffer \
        zaw-rad-docker-image-append-id-to-buffer \
    )
    act_descriptions=(\
        "run" \
        "push" \
        "pull" \
        "inspect" \
        "history" \
        "rmi" \
        "append name to buffer" \
        "append id to buffer" \
    )
    options=(-t "$title" -m)
}

# Helper function to extract $image:$tag or $id from `docker image` output
function zaw-rad-docker-image-extract-fullname() {
    local repo tag id
    repo=$(echo $1 | awk '{print $1}')
    tag=$(echo $1 | awk '{print $2}')
    id=$(echo $1 | awk '{print $3}')

    [[ $tag == '<none>' ]] && echo "$id" || echo "$repo:$tag"
}

function zaw-rad-docker-image-run() {
    zaw-rad-buffer-action "docker run -ti $(zaw-rad-docker-image-extract-fullname $1) bash"
}

function zaw-rad-docker-image-push() {
    zaw-rad-buffer-action "docker push $(zaw-rad-docker-image-extract-fullname $1)"
}

function zaw-rad-docker-image-pull() {
    zaw-rad-buffer-action "docker pull $(zaw-rad-docker-image-extract-fullname $1)"
}

function zaw-rad-docker-image-inspect() {
    zaw-rad-buffer-action "docker inspect $(zaw-rad-docker-image-extract-fullname $1)"
}

function zaw-rad-docker-image-history() {
    zaw-rad-buffer-action "docker history $(zaw-rad-docker-image-extract-fullname $1)"
}

function zaw-rad-docker-image-rmi() {
    zaw-rad-buffer-action "docker rmi $(zaw-rad-docker-image-extract-fullname $1)"
}

function zaw-rad-docker-image-append-name-to-buffer() {
    zaw-rad-buffer-action "$(zaw-rad-docker-image-extract-fullname $1)" accept-search
}

function zaw-rad-docker-image-append-id-to-buffer() {
    zaw-rad-buffer-action "$(echo $1 | awk '{print $3}')" accept-search
}

zaw-register-src -n rad-docker-image zaw-src-rad-docker-image
