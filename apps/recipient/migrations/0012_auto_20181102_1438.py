# -*- coding: utf-8 -*-
# Generated by Django 1.11.13 on 2018-11-02 21:38


from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('recipient', '0011_auto_20171025_1020'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recipientgroup',
            name='created_at',
            field=models.DateTimeField(auto_now_add=True, db_index=True),
        ),
    ]
