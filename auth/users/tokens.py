from django.contrib.auth.hashers import identify_hasher
from rest_framework_simplejwt.serializers import TokenObtainSerializer
from rest_framework_simplejwt.tokens import AccessToken
from rest_framework_simplejwt.views import TokenViewBase
from shared_auth.claims import BRANDS_EDIT, aud, iss


def permission_names(user):
    if user.groups.filter(name="editor").exists():
        return [BRANDS_EDIT]
    return []


class AccessTokenSerializer(TokenObtainSerializer):
    token_class = AccessToken

    @classmethod
    def get_token(cls, user):
        token = cls.token_class.for_user(user)
        token["permissions"] = permission_names(user)
        token["iss"] = iss
        token["aud"] = aud
        return token

    def validate(self, attrs):
        data = super().validate(attrs)
        if identify_hasher(self.user.password).must_update(self.user.password):
            self.user.set_password(attrs["password"])
            self.user.save(update_fields=["password"])
        data["access"] = str(self.get_token(self.user))
        return data


class TokenObtainView(TokenViewBase):
    serializer_class = AccessTokenSerializer
