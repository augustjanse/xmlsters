from django.db import models


class Chart(models.Model):
    placement = models.IntegerField
    mbid = models.CharField(max_length=36)


class User(models.Model):
    chart_id = models.ForeignKey(Chart, on_delete=models.CASCADE)
