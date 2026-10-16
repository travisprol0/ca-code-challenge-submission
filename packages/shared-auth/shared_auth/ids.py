import uuid

NAMESPACE = uuid.uuid5(uuid.NAMESPACE_DNS, "ca-code-challenge.shared-auth")


def public_id_for_wp_user(wp_id):
    return uuid.uuid5(NAMESPACE, f"wp-user:{wp_id}")
