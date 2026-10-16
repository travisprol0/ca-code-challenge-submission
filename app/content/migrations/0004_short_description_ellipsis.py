from django.db import migrations

_SUFFIX = " &hellip;"
_ELLIPSIS = "…"


def rewrite_entity_suffix(apps, schema_editor):
    Brand = apps.get_model("content", "Brand")
    for brand in Brand.objects.all():
        text = brand.short_description or ""
        if not text.endswith(_SUFFIX):
            continue
        brand.short_description = text[: -len(_SUFFIX)] + _ELLIPSIS
        brand.save(update_fields=["short_description"])


class Migration(migrations.Migration):

    dependencies = [
        ("content", "0003_reviewer_public_id_unique"),
    ]

    operations = [
        migrations.RunPython(rewrite_entity_suffix, migrations.RunPython.noop),
    ]
