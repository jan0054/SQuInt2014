package com.squint.app;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.squint.app.adapter.CareerAdapter;
import com.squint.app.widget.BaseActivity;
import android.content.ComponentName;
import android.content.Intent;
import android.content.pm.LabeledIntent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

public class CareerDetailsActivity extends BaseActivity {
	
	public static final String TAG = CareerDetailsActivity.class.getSimpleName();
	public static final String TITLE = "com.squint.app.details.title";
	public static final String SUBJECT = "com.squint.app.details.subject";
	public static final String CONTENT = "com.squint.app.details.content";
	public static final String ACTION = "com.squint.app.details.action";
	private TextView mInstitution;
	private TextView mPosition;
	private TextView mPostedBy;
	private TextView mDescription;
	private TextView mEmail;

	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.details_career);
		mTitle.setText(getString(R.string.title_section3));
		configOptions(OPTION_BACK, OPTION_NONE);
		
		Intent intent 	= getIntent();
		mInstitution 	= (TextView)findViewById(R.id.institution);
		mPosition 		= (TextView)findViewById(R.id.position);
		mPostedBy 		= (TextView)findViewById(R.id.location);
		mDescription 	= (TextView)findViewById(R.id.description);
		mEmail			= (TextView)findViewById(R.id.contact);
		
		mInstitution.setText(intent.getStringExtra(CareerAdapter.EXTRA_CAREER_INSTITUTION));
		mPosition.setText(intent.getStringExtra(CareerAdapter.EXTRA_CAREER_POSITION));
		mPostedBy.setText(getString(R.string.post_by) + " " + intent.getStringExtra(CareerAdapter.EXTRA_CAREER_POSTEDBY));
		mDescription.setText(intent.getStringExtra(CareerAdapter.EXTRA_CAREER_DESCRIPTION));
		
		final String email = intent.getStringExtra(CareerAdapter.EXTRA_CAREER_EMAIL);
		mEmail.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				try {
					sendEmail("About Career - " + mPosition.getText().toString(), "", new String[] {email}, null);
				} catch (IOException e) {
					e.printStackTrace();
				}	
			}		
		});
		
		
		
		
		/*
		mSubject = (TextView)findViewById(R.id.title);
		mContent = (TextView)findViewById(R.id.content);
		mAction = (TextView)findViewById(R.id.action);
				
		Intent intent = getIntent();		
		mTitle.setText(intent.getStringExtra(TITLE));
		mSubject.setText(intent.getStringExtra(SUBJECT));
		mContent.setText(intent.getStringExtra(CONTENT));
		final String action = intent.getStringExtra(ACTION); 
		mAction.setText(action);
		mAction.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {		
					if (action.equals(getString(R.string.action_email_us))) {
						try {
							sendEmail(Params.CONTACTUS_TITLE, Params.CONTACTUS_CONTENT, new String[] {Params.CONTACTUS_EMAIL}, null);
						} catch (IOException e) {
							e.printStackTrace();
						}
					} else if (action.equals(getString(R.string.action_close))) {		
						onBackPressed();
					}
				}			
			});
		 */
	}
	
	@Override
	public void onResume() {		
		super.onResume();
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
	
	
}