
from django.urls import path
from rest_framework import routers
from django.conf.urls import include
from .views import UserViewSet, UserProfileViewSet

router = routers.DefaultRouter()
router.register('user', UserViewSet)
router.register('user_profile', UserProfileViewSet)

urlpatterns = [
    path('', include(router.urls))
]
