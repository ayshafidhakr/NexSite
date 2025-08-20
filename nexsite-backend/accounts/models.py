from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    """
    Custom user model that extends Django's AbstractUser.
    Add extra fields here if needed.
    """
    # Example extra field
    role = models.CharField(
        max_length=20,
        choices=[
            ("single_owner", "Single Owner"),
            ("multi_owner", "Multi Owner"),
            ("employee", "Employee"),
        ],
        default="single_owner"
    )

    def __str__(self):
        return self.username

