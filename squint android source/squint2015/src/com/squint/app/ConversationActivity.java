package com.squint.app;

import com.squint.app.widget.BaseActivity;
import android.os.Bundle;

public class ConversationActivity extends BaseActivity {
	
	public static final String TAG = ConversationActivity.class.getSimpleName();



	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_conversation);		
		mTitle.setText(getString(R.string.title_conversation));		
		configOptions(OPTION_BACK, OPTION_NONE);
	}
	
	@Override
	public void onResume() {		
		super.onResume();
	}

	
}
