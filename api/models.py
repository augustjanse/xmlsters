from django.db import models


class Chart(models.Model):
    placement = models.IntegerField(default=-1)
    mbid = models.CharField(max_length=36)


class User(models.Model):
    chart_id = models.ForeignKey(Chart, related_name='user_id', on_delete=models.CASCADE)
