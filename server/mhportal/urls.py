from django.conf.urls import patterns, include, url
from django.contrib import admin

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'mhportal.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
)


from django.conf.urls import url, include
from rest_framework import routers

from users import views as usr_views
from diary import views as messages_views

router = routers.DefaultRouter()
router.register(r'users', usr_views.SelfUserViewSet)
router.register(r'messages', messages_views.MessageViewSet)

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns += [
    url(r'^api/', include(router.urls)),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    url(r'^dj/get_user/', usr_views.get_user),

]