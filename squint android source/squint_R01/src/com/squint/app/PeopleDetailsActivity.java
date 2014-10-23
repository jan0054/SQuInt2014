package com.squint.app;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.parse.ParseObject;
import com.squint.app.adapter.PeopleAdapter;
import com.squint.app.adapter.PersonalAbstractAdapter;
import com.squint.app.adapter.PersonalPosterAdapter;
import com.squint.app.adapter.PersonalTalkAdapter;
import com.squint.app.data.AbstractDAO;
import com.squint.app.data.PosterDAO;
import com.squint.app.data.PeopleDAO;
import com.squint.app.data.TalkDAO;
import com.squint.app.widget.BaseActivity;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.LabeledIntent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

public class PeopleDetailsActivity extends BaseActivity {
	
	public static final String TAG = PeopleDetailsActivity.class.getSimpleName();
	public static final String TITLE = "com.squint.app.details.title";
	public static final String SUBJECT = "com.squint.app.details.subject";
	public static final String CONTENT = "com.squint.app.details.content";
	public static final String ACTION = "com.squint.app.details.action";
	
	public static final String ACTION_TALK     = "com.squint.app.action.talk";
	public static final String EXTRA_FROM_USER = "com.squint.app.talk.FROM_USER";
	public static final String EXTRA_TO_USER   = "com.squint.app.talk.TO_USER";

	
	private IntentFilter			filter	 = null;  
    private BroadcastReceiver 		receiver = null;
    
	private TextView mAuthor;
	private TextView mInstitution;
	private TextView mEmail;
	private TextView mWebsite;
	private TextView mMessage;
	
	
	// ParseObject
	private ParseObject					  mPerson = null;
	private String						  oid;
	private PeopleDAO					  mPeopleDAO;
	// List
	private TalkDAO 					  mTalkDAO;
	private PosterDAO 					  mPosterDAO;
	private AbstractDAO 				  mAbstractDAO;
	public static List<ParseObject> 	  mTalkData;
	public static List<ParseObject> 	  mPosterData;
	public static List<ParseObject> 	  mAbstractData;
	
	public static PersonalTalkAdapter	  mTalkAdapter;
	public static PersonalPosterAdapter	  mPosterAdapter;
	public static PersonalAbstractAdapter mAbstractAdapter;
	
	public ListView 					  mList;
	private Button 						  mTalk;
	private Button 						  mPoster;
	private Button 						  mAbstract;

	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.details_people);
		// Header Configuration
		mTitle.setText(getString(R.string.title_section2));
		configOptions(OPTION_BACK, OPTION_NONE);
		
		
		Intent intent 	= getIntent();
		oid	= intent.getStringExtra(PeopleAdapter.EXTRA_PERSON_ID);
		final String email 		= intent.getStringExtra(PeopleAdapter.EXTRA_PERSON_EMAIL);
		final String website 	= intent.getStringExtra(PeopleAdapter.EXTRA_PERSON_WEBSITE);
		
		// Retrieve the person data
		//mPeopleDAO = new PeopleDAO(this, oid);	
		
		// Switcher, List, and its data

		mTalkData	= new ArrayList<ParseObject>();
		mPosterData	= new ArrayList<ParseObject>();	
		mAbstractData = new ArrayList<ParseObject>();
		mTalk = (Button)findViewById(R.id.switch_talk);
		mPoster = (Button)findViewById(R.id.switch_poster);
		mAbstract = (Button)findViewById(R.id.switch_abstract);
		mTalk.setOnClickListener(this);
		mPoster.setOnClickListener(this);
		mAbstract.setOnClickListener(this);
		mList = (ListView)findViewById(android.R.id.list);
		mList.setEmptyView(findViewById(android.R.id.empty));
		
		mTalkAdapter = new PersonalTalkAdapter(this, mTalkData);
		mPosterAdapter = new PersonalPosterAdapter(this, mPosterData);
		mAbstractAdapter = new PersonalAbstractAdapter(this, mAbstractData);
		onClick(mTalk);		
	
		mInstitution 	= (TextView)findViewById(R.id.institution);
		mAuthor	 		= (TextView)findViewById(R.id.author);
		mWebsite 		= (TextView)findViewById(R.id.website);
		mMessage 		= (TextView)findViewById(R.id.message);
		mEmail			= (TextView)findViewById(R.id.email);
		
		mAuthor.setText(intent.getStringExtra(PeopleAdapter.EXTRA_PERSON_NAME));
		mInstitution.setText(intent.getStringExtra(PeopleAdapter.EXTRA_PERSON_INSTITUTION));
		mEmail.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				try {
					if (email != null) sendEmail("", "", new String[] {email}, null);
				} catch (IOException e) {
					e.printStackTrace();
				}	
			}		
		});
		
		mWebsite.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {			
				if (website != null) getSite(website);		
			}			
		});
		
		mMessage.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {			
				if (website != null) getConversation(oid);		
			}			
		});
	}
	

	@Override  
    public void onResume() {
        super.onResume();
        
        if (receiver == null) receiver = new IntentReceiver();  
        registerReceiver(receiver, getIntentFilter());
        Log.d(TAG, "onResume");
        if (oid == null) return;
        if (mPerson != null) {
        	Log.d(TAG, "Refresh: " + mPerson.getObjectId());
	        mTalkDAO.refresh();		// = new TalkDAO(this, mPerson);
			mPosterDAO.refresh();	// = new PosterDAO(this, mPerson);
			mAbstractDAO.refresh();	// = new AbstractDAO(this, mPerson); 
        } else {
        	if (mPeopleDAO == null) mPeopleDAO = new PeopleDAO(this, oid);
        	else mPeopleDAO.refresh(oid);
        }
    }
	
	@Override  
    public void onPause() {  
        super.onPause();  
        unregisterReceiver(receiver);
    }
	
	private void sendEmail(String title, String content, String[] emails, Uri imageUri) throws IOException {
		
	    Intent emailIntent = new Intent();
	    emailIntent.setAction(Intent.ACTION_SEND);
    	emailIntent.setType("application/image");
	    if (imageUri != null) {
	    	emailIntent.putExtra(Intent.EXTRA_STREAM, imageUri);	   
	    }
	    
	    Intent openInChooser = Intent.createChooser(emailIntent, "Share");
	    
	    // Extract all package labels
	    PackageManager pm = getPackageManager();
	    
	    Intent sendIntent = new Intent(Intent.ACTION_SEND);     
	    sendIntent.setType("text/plain");
	    
	    List<ResolveInfo> resInfo = pm.queryIntentActivities(sendIntent, 0);
	    List<LabeledIntent> intentList = new ArrayList<LabeledIntent>();
	    
	    for (int i = 0; i < resInfo.size(); i++) {
	        ResolveInfo ri = resInfo.get(i);
	        String packageName = ri.activityInfo.packageName;		        
	        Log.d(TAG, "package: " + packageName);
	        // Append and repackage the packages we want into a LabeledIntent
	        if(packageName.contains("android.email")) {
	            emailIntent.setPackage(packageName);
	        } else if (packageName.contains("android.gm")) 	{		
	            Intent intent = new Intent();
	            intent.setComponent(new ComponentName(packageName, ri.activityInfo.name));
	            intent.setAction(Intent.ACTION_SEND);
	            intent.setType("text/plain");
	            intent.putExtra(Intent.EXTRA_EMAIL,  emails);
				intent.putExtra(Intent.EXTRA_SUBJECT, title);
				intent.putExtra(Intent.EXTRA_TEXT, content);
				if (imageUri != null) {
					intent.setType("message/rfc822");
					intent.putExtra(Intent.EXTRA_STREAM, imageUri);	
				}
	            intentList.add(new LabeledIntent(intent, packageName, ri.loadLabel(pm), ri.icon));
	        }
	    }
	    // convert intentList to array
	    LabeledIntent[] extraIntents = intentList.toArray( new LabeledIntent[ intentList.size() ]);

	    openInChooser.putExtra(Intent.EXTRA_INITIAL_INTENTS, extraIntents);
	    startActivity(openInChooser);
	    
	}
	
    private void getSite(String url) {
        Intent ie = new Intent(Intent.ACTION_VIEW,Uri.parse(url));
        startActivity(ie);
    }
    
    private void getConversation(String objectId) {
    	
    	/* TODO
    	 * 1) Put extra values about device user id and another person id
    	 * 2) Redefine target Class
    	 */
    	Intent intent = new Intent(ACTION_TALK);
    	intent.putExtra(EXTRA_FROM_USER, "from_user_objectId");
    	intent.putExtra(EXTRA_TO_USER, "to_user_objectId");
    	toPage(intent, ConversationActivity.class);
    }
    
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.opt_left:
			onBackPressed();
			break;
		case R.id.switch_talk:
			mList.setAdapter(mTalkAdapter);
			mTalk.setSelected(true);
			mPoster.setSelected(false);
			mAbstract.setSelected(false);
			mTalk.setEnabled(false);
			mPoster.setEnabled(true);
			mAbstract.setEnabled(true);
			break;
		case R.id.switch_poster:
			mList.setAdapter(mPosterAdapter);
			mTalk.setSelected(false);
			mPoster.setSelected(true);
			mAbstract.setSelected(false);
			mTalk.setEnabled(true);
			mPoster.setEnabled(false);
			mAbstract.setEnabled(true);			
			break;
		case R.id.switch_abstract:
			mList.setAdapter(mAbstractAdapter);
			mTalk.setSelected(false);
			mPoster.setSelected(false);
			mAbstract.setSelected(true);
			mTalk.setEnabled(true);
			mPoster.setEnabled(true);
			mAbstract.setEnabled(false);			
			break;
		}
		
	}
	
	private IntentFilter getIntentFilter() {  
        if (filter == null) {  
        	filter = new IntentFilter();  
        	filter.addAction(TalkDAO.ACTION_LOAD_DATA);
        	filter.addAction(PosterDAO.ACTION_LOAD_DATA);
        	filter.addAction(AbstractDAO.ACTION_LOAD_DATA);
        	filter.addAction(PeopleDAO.ACTION_QUERY_DATA);
        	filter.addAction(TalkDetailsActivity.ACTION_SELECT);
        	filter.addAction(PosterDetailsActivity.ACTION_SELECT);
        	filter.addAction(AbstractDetailsActivity.ACTION_SELECT);   	
        }  
        return filter;
    }
	
	class IntentReceiver extends BroadcastReceiver {		  
        @Override  
        public void onReceive(Context context, Intent intent) {
        	Log.d(TAG, "onReceive");	
        	String action = intent.getAction(); 
        	if (action.equals(PeopleDAO.ACTION_QUERY_DATA)) {
            	mPerson = mPeopleDAO.getPersonData();
        		mTalkDAO = new TalkDAO(context, mPerson);
        		mPosterDAO = new PosterDAO(context, mPerson);
        		mAbstractDAO = new AbstractDAO(context, mPerson); 
        		
            } else if (action.equals(TalkDAO.ACTION_LOAD_DATA)) {
            	//mTalkData.clear();
            	//mTalkData.addAll(mTalkDAO.getData());
            	try {
	            	mTalkData = mTalkDAO.getData();
	            	mTalkAdapter.update(mTalkData);
            	} catch (Exception e) { Log.d(TAG, "Talk data is null!"); }
            } else if (action.equals(PosterDAO.ACTION_LOAD_DATA)) {
            	//mPosterData.clear();
            	//mPosterData.addAll(mPosterDAO.getData());
            	try {
            	mPosterData = mPosterDAO.getData();
            	mPosterAdapter.update(mPosterData);
            	} catch (Exception e) { Log.d(TAG, "Poster data is null!"); }
            } else if (action.equals(AbstractDAO.ACTION_LOAD_DATA)) {
            	//mAbstractData.clear();
            	//mAbstractData.addAll(mAbstractDAO.getData());
            	try {
            	mAbstractData = mAbstractDAO.getData();
            	mAbstractAdapter.update(mAbstractData);
            	} catch (Exception e) { Log.d(TAG, "Abstract data is null!"); }
            } else if (action.equals(TalkDetailsActivity.ACTION_SELECT)) {
            	toPage(intent, TalkDetailsActivity.class);

            } else if (action.equals(PosterDetailsActivity.ACTION_SELECT)) {
            	toPage(intent, PosterDetailsActivity.class);
            	
            } else if (action.equals(AbstractDetailsActivity.ACTION_SELECT)) {
            	toPage(intent, AbstractDetailsActivity.class);
            	
            }       
        }  
    }
	
}
