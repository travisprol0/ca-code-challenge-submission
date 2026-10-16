from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('content', '0002_industry_name'),
    ]

    operations = [
        migrations.AlterField(
            model_name='reviewer',
            name='public_id',
            field=models.UUIDField(unique=True),
        ),
    ]
