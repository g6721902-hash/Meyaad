# ميعاد | MEYAAD — Starter Project

Arabic RTL Flutter starter for a doctor appointment and queue app, initially scoped to Nasiriyah.

## Included
- Arabic patient home screen and specialty filters.
- Sample doctor cards and demo appointment confirmation flow.
- Embedded Google Map screen showing clinic marker, address and coordinates.
- Initial doctor dashboard screen.
- Supabase SQL schema for profiles, doctors, clinics, schedules, appointments,
  queue entries and notifications.

## Run
1. Install Flutter SDK and Android Studio / Android SDK.
2. Extract the ZIP.
3. Run `flutter pub get`.
4. Configure a Google Maps API key for Android (see below).
5. Run `flutter run` on an Android device or emulator.

## Google Maps setup
The map requires a Google Cloud project, billing configuration where required,
Maps SDK for Android enabled, and a restricted API key. Add the key in the
Android app manifest under the `<application>` element as a
`com.google.android.geo.API_KEY` metadata entry. Restrict it to this Android
package and signing certificate. Never commit an unrestricted key to GitHub.

## Supabase setup
Create a Supabase project and apply `supabase/schema.sql`. Configure auth and
environment values before adding the Supabase client to the app. Add and test
Row Level Security policies before any real patient data is stored.

## Honest status
This ZIP is a runnable UI scaffold after dependency and Maps setup, not a complete
production service. Demo doctors, clinic coordinates and appointments are sample
data only. SMS OTP, live Supabase queries, transaction-safe booking, real-time
queue updates, push notifications, doctor verification, patient geolocation,
and production RLS policies remain to be implemented and tested.

Do not advertise demo listings as real doctors or use sample coordinates as actual
clinic locations.


## Build APK using GitHub Actions (no local Flutter install required)
1. Create a GitHub repository for the project.
2. Extract this ZIP and upload the *contents* into the repository root (not the ZIP itself).
3. Open the repository's **Actions** tab.
4. Select **Build Meyaad APK** and press **Run workflow**, or push a commit to `main`/`master`.
5. When the workflow succeeds, open the run, scroll to **Artifacts**, and download `meyaad-release-apk`.
6. Extract the downloaded artifact ZIP to get `app-release.apk`.

Notes:
- The workflow generates the Android platform files and compiles the Flutter project.
- Google Maps needs a restricted Android Maps API key and Google Maps SDK enabled for the map to display correctly. Without it, the APK may build but the map may be blank or show a key error.
- The included doctor names, schedules, and coordinates are demo data, not real clinics. Booking, authentication, Supabase live data, and real-time queue updates are not production-enabled yet.
