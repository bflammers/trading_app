
from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import action
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAdminUser, AllowAny  # , IsAuthenticated Already default in settings

from .serializers import UserSerializer, UserProfileSerializer
from .models import User, UserProfile


# class UserViewSet(viewsets.ModelViewSet):
#     queryset = User.objects.all()
#     serializer_class = UserSerializer
#     authentication_classes = (TokenAuthentication, )
#     permission_classes = (AllowAny, )

class UserViewSet(viewsets.ModelViewSet):
        queryset = User.objects.all()
        serializer_class = UserSerializer

class UserProfileViewSet(viewsets.ModelViewSet):
        queryset = UserProfile.objects.all()
        serializer_class = UserProfileSerializer
