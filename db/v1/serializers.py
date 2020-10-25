
from rest_framework import serializers
from rest_framework.authtoken.models import Token

from .models import User, UserProfile


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ('id', 'username', 'password', 'first_name', 'last_name', 'email')
        extra_kwargs = {
            'password': {
                'write_only': True,
                'required': True
            }
        }


class UserProfileSerializer(serializers.ModelSerializer):

    user = UserSerializer(many=False, required=True)

    class Meta:
        model = UserProfile
        fields = ('user', 'created_at', 'updated_at', 'gender')
        read_only_fields = ('created_at', 'updated_at',)

    def create(self, validated_data):
        user_data = validated_data.pop('user', {})
        user = User.objects.create(**user_data)

        profile = UserProfile.objects.create(user = user, **validated_data)
    
        return profile

    def update(self, instance, validated_data):
        # First, update the User
        user_data = validated_data.pop('user', {})
        user = User.objects.get(id=instance.user.id)
        for attr, value in user_data.items():
            setattr(user, attr, value)
        user.save()

        # Then, update UserProfile
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        return instance


    