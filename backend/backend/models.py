from django.db import models

def Profle(models.Model):
	games_played = models.IntegerField()
	lifetime_score = models.IntegerField()
	high_score = models.IntegerField()
	best_game = models.IntegerField()
	best_questions = models.IntegerField()
	best_fast = models.IntegerField()

def Question(models.Model):
	text = models.CharField(max_length=250)
	is_fast = models.BooleanField(default=False)
	
def Answers(models.Model):
	text = models.CharField(max_length=250)
	points = models.IntegerField()