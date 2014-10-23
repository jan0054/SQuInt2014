package com.squint.app;

import com.squint.app.widget.BaseActivity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;

public class PosterDetailsActivity extends BaseActivity {
	
	public static final String TAG = PosterDetailsActivity.class.getSimpleName();
	public static final String 		ACTION_SELECT 			    	= "com.squint.action.poster.select";
	public static final String 		EXTRA_POSTER_ID	  			    = "com.squint.data.poster.ID";
	public static final String 		EXTRA_POSTER_NAME	  			= "com.squint.data.poster.NAME";
	public static final String 		EXTRA_POSTER_AUTHOR	  		    = "com.squint.data.poster.AUTHOR";
	public static final String 		EXTRA_POSTER_DESCRIPTION	  	= "com.squint.data.poster.DESCRIPTION";	
	public static final String 		EXTRA_POSTER_AUTHOR_ID	    	= "com.squint.data.poster.AUTHOR_ID";
	public static final String 		EXTRA_POSTER_LOCATION_NAME 	    = "com.squint.data.poster.LOCATION.NAME";
	public static final String 		EXTRA_POSTER_ABSTRACT_ID 	    = "com.squint.data.poster.ABSTRACT_ID";
	public static final String 		EXTRA_POSTER_ABSTRACT_PDF 	    = "com.squint.data.poster.ABSTRACT_PDF";
	public static final String 		EXTRA_POSTER_ABSTRACT_CONTENT   = "com.squint.data.poster.ABSTRACT_CONTENT";

	private TextView 		mName;
	private TextView 		mAuthor;
	private TextView 		mLocation;
	private TextView 		mDetails;
	private TextView 		mDescription;
	private TextView 		mAbstract;	
	
	// ParseObject
	private static String  oid;
	private static String  absPdf;
	private static String  absContent;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.details_poster);
		// Header Configuration
		mTitle.setText(getString(R.string.title_section1));
		configOptions(OPTION_BACK, OPTION_NONE);
				
		mName 			= (TextView)findViewById(R.id.name);
		mAuthor	 		= (TextView)findViewById(R.id.author);
		mLocation 		= (TextView)findViewById(R.id.location);
		mDescription 	= (TextView)findViewById(R.id.description);
		mDetails 		= (TextView)findViewById(R.id.author_details);
		mAbstract		= (TextView)findViewById(R.id.btn_abstract);	
	}
	
	@Override
	public void onResume() {
		super.onResume();
		
		Intent intent 	= getIntent();
		oid	= intent.getStringExtra(EXTRA_POSTER_ID);
		absPdf = intent.getStringExtra(EXTRA_POSTER_ABSTRACT_PDF);
		absContent = intent.getStringExtra(EXTRA_POSTER_ABSTRACT_CONTENT);
		
		
		mName.setText(intent.getStringExtra(EXTRA_POSTER_NAME));
		mAuthor.setText(intent.getStringExtra(EXTRA_POSTER_AUTHOR));
		mLocation.setText(intent.getStringExtra(EXTRA_POSTER_LOCATION_NAME));
		mDescription.setText(intent.getStringExtra(EXTRA_POSTER_DESCRIPTION));
		
		mDetails.setContentDescription(intent.getStringExtra(EXTRA_POSTER_AUTHOR_ID));
		mDetails.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				String details = v.getContentDescription().toString();
				Log.d(TAG, "oid/details: " + oid + "/ " + details);				
			}
		});
		
		mAbstract.setContentDescription(intent.getStringExtra(EXTRA_POSTER_ABSTRACT_ID));
		mAbstract.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				//String abstractId = v.getContentDescription().toString();
				//Log.d(TAG, "oid/abstract: " + oid + "/ " + abstractId);		
				
				Intent intent = new Intent(AbstractDetailsActivity.ACTION_SELECT);
				
				intent.putExtra(AbstractDetailsActivity.EXTRA_ABSTRACT_ID, getAbstractId());
				intent.putExtra(AbstractDetailsActivity.EXTRA_ABSTRACT_NAME, getName());
				intent.putExtra(AbstractDetailsActivity.EXTRA_ABSTRACT_AUTHOR, getAuthor());
				intent.putExtra(AbstractDetailsActivity.EXTRA_ABSTRACT_AUTHOR_ID, getAuthorId());
				intent.putExtra(AbstractDetailsActivity.EXTRA_ABSTRACT_PDF, getAbstractPdf());
				intent.putExtra(AbstractDetailsActivity.EXTRA_ABSTRACT_CONTENT, getAbstractContent());
				
				toPage(intent, AbstractDetailsActivity.class);
				
			}			
		});
		
	}
	
	private String getName() {
		return mName.getText().toString();
	}
	
	private String getAuthor() {
		return mAuthor.getText().toString();
	}
	
	private String getAuthorId() {
		return mDetails.getContentDescription().toString();
	}
	
	private String getAbstractId() {
		return mAbstract.getContentDescription().toString();
	}
	
	private String getAbstractContent() {
		return absContent;
	}
	
	private String getAbstractPdf() {
		return absPdf;
	}
	

	
}
