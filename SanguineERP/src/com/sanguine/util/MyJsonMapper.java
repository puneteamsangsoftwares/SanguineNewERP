package com.sanguine.util;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

public class MyJsonMapper extends ObjectMapper {    
    /**
	 * 
	 */

	public MyJsonMapper() {
		/*this.setVisibility(PropertyAccessor.FIELD, Visibility.ANY);
		this.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
        */

		this.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        this.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);
    }
    
    /*@Bean 
    public MappingJackson2HttpMessageConverter mappingJackson2HttpMessageConverter()
    { 
    	ObjectMapper mapper = new ObjectMapper();
    	mapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false); 
    	MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter(mapper);
    	return converter; 
    } */
}
