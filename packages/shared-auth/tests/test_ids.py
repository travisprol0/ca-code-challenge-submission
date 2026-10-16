from shared_auth.ids import public_id_for_wp_user

USER_2 = "d92149dc-6588-5f3e-82c5-dd65c462fb96"


def test_public_id_for_wp_user_2():
    assert str(public_id_for_wp_user(2)) == USER_2
