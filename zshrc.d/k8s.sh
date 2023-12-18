ssh-k8s() {
    NAMESPACE=$1
    POD_NAME=$2
    CONTAINER_NAME=$3

    if [[ -z "$NAMESPACE" ]]; then
        echo "Namespace must be provided."
        return 1
    fi

    if [[ -z "$POD_NAME" ]]; then
        echo "Pod name must be provided."
        return 1
    fi

    if [[ -z "$CONTAINER_NAME" ]]; then
        # If container name is not provided, it will try to get a shell in the first container of the pod
        kubectl -n "$NAMESPACE" exec -it "$POD_NAME" -- /bin/bash
    else
        kubectl -n "$NAMESPACE" exec -it "$POD_NAME" -c "$CONTAINER_NAME" -- /bin/bash
    fi
}
