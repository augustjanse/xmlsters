from django.conf.urls import url
from rest_framework.urlpatterns import format_suffix_patterns

from api.views import CreateChart

urlpatterns = {
    url(r'^create$', CreateChart.as_view(), name="create")
}

urlpatterns = format_suffix_patterns(urlpatterns)
