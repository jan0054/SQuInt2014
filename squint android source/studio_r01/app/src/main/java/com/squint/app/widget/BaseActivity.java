package com.squint.app.widget;

import com.parse.Parse;
import com.parse.ParseUser;
import com.squint.app.R;
import com.squint.app.data._PARAMS;

import android.app.ActionBar;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TextView;
import android.widget.Toast;

public class BaseActivity extends FragmentActivity implements OnClickListener {
	
	public static final String		TAG = BaseActivity.class.getSimpleName();
	
	public ActionBar	mActionBar;
	public TextView		mTitle;
	public TintableImageView	mOptionLeft;
	public TintableImageView	mOptionRight;
	public TintableImageView	mOptionExtraLeft;
	public TintableImageView	mOptionExtraRight;
	
	public final static int OPTION_NONE			= 0;
	public final static int OPTION_BACK			= R.drawable.actionbar_back;
	public final static int OPTION_TALK			= R.drawable.actionbar_talk;
	public final static int OPTION_LOGIN 		= R.drawable.actionbar_login;
	public final static int OPTION_LOGOUT		= R.drawable.actionbar_logout;
	
	public static final String FROM = "from";
	public static final String USER = "user";

	
	//private LayoutInflater 	layoutInflater;
	//private View 				progress_layout;
	//private FrameLayout 		container;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		// Initial Parse
		new Thread(new Runnable() {
	        @Override
	        public void run() {     
        		Parse.initialize(getBaseContext(), _PARAMS.APPLICATION_ID, _PARAMS.CLIENT_KEY);
	        }
	    }).start();
		
        mActionBar = getActionBar();
		mActionBar.setDisplayOptions(ActionBar.DISPLAY_SHOW_CUSTOM);
        mActionBar.setCustomView(R.layout.actionbar);
		mActionBar.setDisplayShowHomeEnabled(false);
		mActionBar.setBackgroundDrawable(getResources().getDrawable(R.drawable.header_gradient_background));
		mActionBar.setDisplayUseLogoEnabled(false);
		mActionBar.setDisplayShowTitleEnabled(false);
		//mActionBar.setLogo(R.drawable.bg_transp);
		//mActionBar.setIcon(R.drawable.bg_transp);
		View view = mActionBar.getCustomView();
		mTitle = (TextView)view.findViewById(R.id.title);
		
		mOptionLeft = (TintableImageView)view.findViewById(R.id.opt_left);
		mOptionRight = (TintableImageView)view.findViewById(R.id.opt_right);
		mOptionExtraLeft = (TintableImageView)view.findViewById(R.id.opt_extra_left);
		mOptionExtraRight = (TintableImageView)view.findViewById(R.id.opt_extra_right);
		
		mOptionLeft.setOnClickListener(this);
		mOptionRight.setOnClickListener(this);
		mOptionExtraLeft.setOnClickListener(this);
		mOptionExtraRight.setOnClickListener(this);
		
		
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		if (item.getItemId() == android.R.id.home) {
			onBackPressed();
			return true;
		} else return super.onOptionsItemSelected(item);
	}
	
	@Override
	  protected void onResume()
	  {
	    super.onResume();
	    //opening transition animations
	    //overridePendingTransition(R.anim.page_translate_open,R.anim.page_scale_close);
	  }

	  @Override
	  protected void onPause()
	  {
	    super.onPause();
	    //closing transition animations
	    //overridePendingTransition(R.anim.page_scale_open,R.anim.page_translate_close);
	  }
	
	@Override
	public void onBackPressed() {
		super.onBackPressed();
	    overridePendingTransition (R.anim.page_right_slide_in, R.anim.page_right_slide_out);
	}
	
	
	
    public final boolean isNetwork() {    	
	    ConnectivityManager connection = (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
	    NetworkInfo info = connection.getActiveNetworkInfo();
	    return (info != null && info.isConnected());
    }
    
	public boolean isLogin() {
		ParseUser user = ParseUser.getCurrentUser();
		Log.d(TAG, "User Existing: " + (user != null));
		return (user != null);
	}
    
    
    
    public void clearOptions() {
    	mOptionLeft.setImageDrawable(null);
    	mOptionRight.setImageDrawable(null);
    	mOptionLeft.setVisibility(View.GONE);
    	mOptionRight.setVisibility(View.GONE);
    }
    
    public void configOptions(int leftDrawableId, int rightDrawableId) {
    	if (leftDrawableId != OPTION_NONE) {
	    	mOptionLeft.setImageResource(leftDrawableId);
	    	mOptionLeft.setTag(leftDrawableId);
	    	mOptionLeft.setVisibility(View.VISIBLE);
    	} else {
	    	mOptionLeft.setImageDrawable(null);
	    	mOptionLeft.setVisibility(View.GONE);    		
    	}
    	if (rightDrawableId != OPTION_NONE) {
	    	mOptionRight.setImageResource(rightDrawableId);
	    	mOptionRight.setTag(rightDrawableId);
	    	mOptionRight.setVisibility(View.VISIBLE);
    	} else {
    		mOptionRight.setImageDrawable(null);
    		mOptionRight.setVisibility(View.GONE);    		
    	}
    }
    
    public void connectionAlert() {
        new AlertDialog.Builder(this)
     		.setMessage(getString(R.string.dialog_network_error_content)) 
     		.setTitle(getString(R.string.dialog_network_error_title)) 
     		.setCancelable(true) 
     		.setNeutralButton(getString(android.R.string.ok), 
        new DialogInterface.OnClickListener() { 
     		@Override
			public void onClick(DialogInterface dialog, int whichButton){
     			//finish(); 
     		}
     		}).show(); 
     }
    
    public void showAlert(String title, String message) {
        new AlertDialog.Builder(this)
     		.setMessage(message) 
     		.setTitle(title) 
     		.setCancelable(true) 
     		.setNeutralButton(getString(android.R.string.ok), 
        new DialogInterface.OnClickListener() { 
     		@Override
			public void onClick(DialogInterface dialog, int whichButton){
     			//finish(); 
     		}
     		}).show(); 
     }

    
	@Override
	public void onClick(View v) {		
		if((Integer)v.getTag() == OPTION_BACK) {
			onBackPressed();
		}
	}
	
	public <T> void toPage(Intent intent, Class<T> cls) {
		intent.setClass(this, cls); //PeopleDetailsActivity.class);
		startActivity(intent);
	    overridePendingTransition (R.anim.page_left_slide_in, R.anim.page_left_slide_out);
	}
	
	public void toast(String message) {
    	Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
	}
}
