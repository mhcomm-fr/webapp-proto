from django.views.decorators.csrf import ensure_csrf_cookie
from django.http import (HttpResponseRedirect, HttpResponseForbidden)
#from django.core.urlresolvers import reverse
from django.contrib.auth.models import User

from rest_framework.decorators import api_view
from rest_framework import viewsets
from rest_framework.reverse import reverse

from users import serializers


@api_view(http_method_names=['GET'])
@ensure_csrf_cookie
def get_user(request):
    u = request.user
    if u.is_authenticated():
        redirect_to = reverse('user-detail', kwargs={'pk': u.pk}, request=request)

        return HttpResponseRedirect(redirect_to)
    return HttpResponseForbidden()


class SelfUserViewSet(viewsets.ModelViewSet):
    """
    A viewset for viewing and editing users, only accessible by themselves.
    """
    serializer_class = serializers.UserSerializer
    queryset = User.objects.all()

    def permission_self(self, request, obj):
        return obj

    def get_queryset(self):
        if self.request.user.is_authenticated():
            qs = self.queryset
            qs = qs.filter(id=self.request.user.id)
            return qs
        else:
            return []