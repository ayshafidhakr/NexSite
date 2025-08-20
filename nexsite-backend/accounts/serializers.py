from rest_framework import serializers
from .models import User


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password_confirm = serializers.CharField(write_only=True)
    full_name = serializers.CharField(write_only=True)  # ✅ not in DB, but still accepted

    class Meta:
        model = User
        fields = [
            'username',
            'full_name',
            'email',
            'role',  # from your custom User model
            'password',
            'password_confirm'
        ]

    def validate(self, attrs):
        # ✅ Check password match
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError({"password": "Passwords do not match."})
        return attrs

    def create(self, validated_data):
        full_name = validated_data.pop('full_name', None)
        password = validated_data.pop('password')
        validated_data.pop('password_confirm', None)

        user = User(**validated_data)

        # ✅ Split full_name into first_name and last_name
        if full_name:
            parts = full_name.split(" ", 1)
            user.first_name = parts[0]
            if len(parts) > 1:
                user.last_name = parts[1]

        # ✅ Hash password
        user.set_password(password)
        user.save()
        return user


class UserSerializer(serializers.ModelSerializer):
    """ Serializer for returning user data (e.g., after login) """
    full_name = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'full_name', 'email', 'role']

    def get_full_name(self, obj):
        return f"{obj.first_name} {obj.last_name}".strip()
