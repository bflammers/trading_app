
from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver
# from django_countries.fields import CountryField

GENDERS = [(0, 'Male'), (1, "Female")]

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    gender = models.CharField(choices = GENDERS, default = 2, max_length = 64)
    # country = CountryField()
    birth_date = models.DateField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add = True)
    updated_at = models.DateTimeField(auto_now = True)


