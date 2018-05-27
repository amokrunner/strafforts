module Api
  class Faqs # rubocop:disable ClassLength
    def initialize # rubocop:disable MethodLength
      @faqs = []

      add('account', 'Does Strafforts need/store my Strava password?', "
<p>No, Strafforts connects to your Strava account via
Strava's <a href='https://strava.github.io/api/v3/oauth/' target='_blank'>authentication API</a>.</p>
<p>It means all you need to do is to login to your Strava account then connect Strafforts with Strava and
no sensitive information will be stored on Strafforts server at all.</p>")
      add('account', 'Is it possible to remove all my data on Strafforts?', "
<p>Yes, abusolutely. First make sure you have connected and logged into Strafforts,
then go to your 'Settings' sidebar by clicking <code><i class='fa fa-gears'></i></code> at top right corner of the app,
and choosing <code><i class='fa fa-wrench'></i></code> tab,
then click 'Delete' button to remove yourself from Strafforts server.</p>
<p>If you've changed your mind,
you can re-connect to give Strafforts permission to retrieve your Strava data again.
However, since all data has been deleted on our server, it might take a while to retrieve everything again.</p>
<p><b>Note:</b> If you had PRO subscriptions, they will be gone too.</p>")
      add('account', 'Does Strafforts share my data to any third parties?', "
<p>Not at all! Strafforts only gets your Strava data with your permission
and displays to you via tables and charts for analysis.</p>")

      add('best-efforts', 'How is "Best Efforts" different from "Personal Bests"?', "
<p>As the names suggest, 'Personal bests' on Strafforts are PBs/PRs,
more specifically, they are those gold best estimated efforts trophies on Strava running activities,
while 'Best Efforts' are not neccessarily PBs/PRs,
but your top 100 best bests of each distance.</p>
<p>For example, if your current 5k PB is 17:00, and you ran 17:10 today,
17:10 is not your PB/PR and won't show up in 'Personal Bests' view,
but mostly likely to be included in 'Best Efforts' (if 17:10 is within top 100 of all your 5k efforts).</p>")

      add('personal-bests', "Why can't I find some of my personal bests?", "
<p>Personal bests on Strafforts are just those gold best estimated efforts trophies on Strava running activities.</p>
<p>First please check if the best effort you are looking for do exist on the corresponding Strava activity.
If it does exist on Strava, but not Strafforts, please contact me
(See 'How to contact Strafforts support?' section).</p>
<p>If it doesn't exist on Strava either, please submit a request at Strava's support site
<a href='https://support.strava.com/hc/en-us/requests/new' target='_blank'>here</a>.</p>
<p><b>Note:</b> Strava's best effort only starts counting from the 2nd best effort of such distance.
See <a href='https://support.strava.com/hc/en-us/articles/216917137-Achievement-Awards-Glossary'>
Achievement Awards Glossary</a> for more details.</p>")
      add('personal-bests', 'Why there are some outliers in my PB progression chart?', "
<p>All PBs/PRs here in Strafforts are just those
gold best estimated efforts trophies on Strava running activities.</p>
<p>Sometimes PBs/PRs on Strava can be generated unpredictably and unreliably.</p>
<p>If you notice some messed up PBs/PRs within Strafforts,
you can try go to those activities on Strava and try
'<a href='https://support.strava.com/hc/en-us/articles/216919597-The-Refresh-My-Achievements-Tool-'
target='_blank'>Refresh Activity Achievements</a>',
or '<a href='https://support.strava.com/hc/en-us/requests/new' target='_blank'>Submit a request</a>'
on Strava support site regarding your wrong Strava best efforts data.</p>
<p>Then reset your last retrieved activity here in your setting
to trigger a complete re-fetch of your activities.</p>
")
      add('personal-bests', 'Why my activity is shown under another distance?', "
<p>Strafforts' personal bests are just visual representations of those Strava gold best estimated efforts trophies.</p>
<p>If you made a best 20k effort within a full marathon activity,
there will be a gold 20k trophy on this activity on Strava,
therefore Strafforts will pick it up and display it as well.</p>
<p>This means one activity may have multiple personal bests over different distances,
therefore this activity may be shown under different distances in Strafforts.</p>")
      add('personal-bests', 'How to recalculate all best estimated efforts on Strava?', "
<p>The quick answer is - no, you can't.</p>
<p>Sometimes an activity was uploaded as wrong activity type,
which was so fast that created few 1st best efforts trophies.
Then the athlete realized it and changed the activity to something else.
But those 1st best efforts trophies would remain there.
All subsequent best efforts can only be '2nd best efforts'.</p>
<p>In order to solve this problem, Strava provides
'<a href='https://support.strava.com/hc/en-us/articles/216919597-The-Refresh-My-Achievements-Tool-'
target='_blank'>Refresh Activity Achievements</a>' tool in the UI,
which allows users to recalculate the best efforts.</p>
<p>However, the way it was designed is to recalculate best efforts for only this particular activity based on
all activities at the time when this action was taken.
It won't recalculate all best efforts on all activities in a timely fashion.
This means if the athlete realized the situation too late,
that there have 2nd best efforts, 3rd best efforts in other activities uploaded after this activity,
refreshing the achievements will result in nothing.
Because at the refreshing process, Strava will treat the later activities as 1st, 2nd and so on.
But since you are not refreshing those activities, best efforts on those activities won't be updated.</p>
<p>Say for example,</p>
<ul>
<li>Activity ID 11111: 5k 10 minutes, 1st best efforts for 5k</li>
<li>Activity ID 22222: 5k 25 minutes, 2nd best efforts for 5k</li>
<li>Activity ID 33333: 5k 21 minutes, 2nd best efforts for 5k</li>
<li>Activity ID 44444: 5k 23 minutes, 3rd best efforts for 5k</li>
</ul>
<p>Then activity 11111 was refreshed due to wrong activity type,
so there will be no more '1st best efforts' for 5k on this activity.
All other activities will remain the same too, which means there is no more '1st best efforts' on any activities.
If you refresh the achievements of 22222 now, it will become '3rd best efforts for 5k'.
Because Strava recalculates achievements based on all existing activities as of the time refreshing is done,
25 minutes is only the '3rd best efforts for 5k' now. So the athlete would never get '1st best efforts' back.</p>
")

      add('races', 'What are "Races" and how to create them?', "
<p>Strava offers four different sub-categories within the Running activity type to allow
for more detailed and focused analysis of your training.
Those four tags are Run, Race, Long Run, and Workout.</p>
<p>Activties that are tagged as <code>Race</code> will be fetched and analyzed by Strafforts,
then displayed within distance or year view, as well as timeline view.</p>
<p><img src='/screenshots/doc-tag-run-as-race.png' style='width:85%;'></p>
<p>For more details,
see <a href='https://support.strava.com/hc/en-us/articles/216919557-Using-Strava-Run-Type-Tags-to-analyze-your-Runs'
target='_blank'>What are Strava races and how to create them?</a> on Strava support forum.</p>")
      add('races', 'How race distances are determined?', "
<p>Race distance is determined by the actual distance of a Strava activity.
If it's within 2.5% under or 5% over margin of a pre-defined distance (10k for example),
Strafforts will treat it as a 10k race.</p>
<p>If the actual distance of your 10k race is 9.7km or 10.5km,
then Strafforts will put this activity under distance of 'Other Distances'.</p>")
      add('races', 'Why my race is categorized as "Other Distances"?', "
<p>Same as above. Race distance is determined by the actual distance of a Strava activity.
If it's within 2.5% under or 5% over margin of a pre-defined distance (10k for example),
Strafforts will treat it as a 10k race.</p>
<p>If the actual distance of your 10k race is 9.7km or 10.5km,
then Strafforts will put this activity under distance of 'Other Distances'.
</p>")

      add('miscellaneous', 'What technologies are used in Strafforts?', "
<p>See <a href='https://github.com/yizeng/strafforts/blob/master/docs/acknowledgements.md'
target='_blank'>Acknowledgements page</a> for a comprehensive list.</p>")
      add('miscellaneous', 'How to contribute to Strafforts?', "
<p>Strafforts is an open source project licensed under
<a href='https://github.com/yizeng/strafforts/blob/master/LICENSE' target='_blank'>AGPLv 3</a>
and hosted on <a href='https://github.com/yizeng/strafforts/' target='_blank'>GitHub</a>.</p>
<p>You can <a href='https://github.com/yizeng/strafforts/issues' target='_blank'>raise issues</a>,
<a href='https://github.com/yizeng/strafforts/pulls' target='_blank'>provide PRs</a> or even simply
<a href='https://donorbox.org/help-push-strafforts-forward?amount=25' target='_blank'>donate</a>.</p>")
      add('miscellaneous', 'Where was the homepage background photo taken?', "
<p>The photo was taken in Listbon, Portugal, and the bridge in the background is the
<a href='https://en.wikipedia.org/wiki/25_de_Abril_Bridge' target='_blank'>25 de Abril Bridge</a>.</p>
<p>It was the period I started this project while travelling in Europe,
where I did Lisbon Rock'n'Roll half marathon.</p>")

      add('support', 'How to contact Strava support?', "
You can submit a request at Strava's support site
<a href='https://support.strava.com/hc/en-us/requests/new' target='_blank'>here</a>.")
      add('support', 'How to contact Strafforts support?', "
<p>Please email us at <a href='mailto:support@strafforts.com'>support@strafforts.com</a> with your enquiries.</p>
<p>Alternatively, if you have a GitHub account,
you can also raise an issue <a href='https://github.com/yizeng/strafforts/issues' target='_blank'>here</a>.
</p>")
    end

    def to_json
      @faqs.to_json
    end

    private

    def add(category, title, content)
      faq = { category: category, title: title, content: content }
      @faqs.push(faq)
    end
  end

  class FaqsController < ApplicationController
    def index
      faqs = Faqs.new
      render json: faqs.to_json
    end
  end
end
