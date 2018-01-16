from django.conf.urls import url
from rest_framework.urlpatterns import format_suffix_patterns

from api.views import CreateView

urlpatterns = {
    url(r'^charts/$', CreateView.as_view(), name="create")
}

urlpatterns = format_suffix_patterns(urlpatterns)
